package test

import (
	"fmt"
	"os"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/shell"
	"github.com/gruntwork-io/terratest/modules/terraform"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

func TestTerraformCertManagerRoute53(t *testing.T) {
	t.Parallel()

	kubeconfig_file := os.Getenv("KUBECONFIG")
	if len(kubeconfig_file) == 0 {
		kubeconfig_file = "~/.kube/config"
	}

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/cert-manager-route53/",
		Vars: map[string]interface{}{
			"kubeconfig": kubeconfig_file,
		},
	}
	terraformTestOptions := &terraform.Options{
		TerraformDir: "./test-ingress",
		Vars: map[string]interface{}{
			"kubeconfig": kubeconfig_file,
		},
	}

	terraform.InitAndApply(t, terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	namespace := terraform.Output(t, terraformOptions, "namespace")
	podsLabels := []string{
		"app.kubernetes.io/component=controller,app.kubernetes.io/instance=cert-manager",
		"app.kubernetes.io/component=cainjector,app.kubernetes.io/instance=cert-manager",
		"app.kubernetes.io/component=webhook,app.kubernetes.io/instance=cert-manager",
	}
	options := k8s.NewKubectlOptions("", kubeconfig_file, namespace)
	for _, v := range podsLabels {
		k8s.WaitUntilNumPodsCreated(t, options, metav1.ListOptions{LabelSelector: v}, 1, 20, time.Second*10)
	}

	// test ingress

	terraform.InitAndApply(t, terraformTestOptions)
	defer terraform.Destroy(t, terraformTestOptions)

	secretName := terraform.Output(t, terraformTestOptions, "secret_name")
	maxRetries := 30
	sleepBetweenRetries := 4 * time.Second

	kubectlCheckCert := "kubectl get cert " + secretName + " -o jsonpath='{.status.conditions[0].reason}'|grep Ready"
	t.Logf("DEBUG: kubectl cmd: %s", kubectlCheckCert)

	getCertCmd := shell.Command{
		Command: "bash",
		Args:    []string{"-c", kubectlCheckCert},
	}
	retry.DoWithRetry(t, "Checking if certificate '"+secretName+"' has been signed", maxRetries, sleepBetweenRetries, func() (string, error) {
		if out, err := shell.RunCommandAndGetOutputE(t, getCertCmd); err != nil {
			return "", fmt.Errorf("Not yet..: (output=%s err=%s)", out, err)
		}
		return "", nil
	})
}
