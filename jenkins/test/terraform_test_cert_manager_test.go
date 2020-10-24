package test

import (
	"os"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/k8s"
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
		TerraformDir: "../../../examples/cert-manager-route53/",
		Vars: map[string]interface{}{
			"kubeconfig": kubeconfig_file,
		},
	}

	terraform.InitAndApply(t, terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	namespace := terraform.Output(t, terraformOptions, "namespace")

	pods_labels := []string{
		"app.kubernetes.io/component=controller,app.kubernetes.io/instance=cert-manager",
		"app.kubernetes.io/component=cainjector,app.kubernetes.io/instance=cert-manager",
		"app.kubernetes.io/component=webhook,app.kubernetes.io/instance=cert-manager",
	}
	options := k8s.NewKubectlOptions("", kubeconfig_file, namespace)
	for _, v := range pods_labels {
		k8s.WaitUntilNumPodsCreated(t, options, metav1.ListOptions{LabelSelector: v}, 1, 20, time.Second*10)
	}

}
