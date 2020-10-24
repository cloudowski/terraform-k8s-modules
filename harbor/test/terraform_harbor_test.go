package test

import (
	"fmt"
	"os"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformHarbor(t *testing.T) {
	t.Parallel()

	kubeconfig_file := os.Getenv("KUBECONFIG")
	if len(kubeconfig_file) == 0 {
		kubeconfig_file = "~/.kube/config"
	}

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/harbor/",
		// Vars: map[string]interface{}{
		// 	"kubeconfig": kubeconfig_file,
		// },
	}

	terraform.InitAndApply(t, terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)
	defer retry.DoWithRetry(t, "Destroying..", 3, 3*time.Second, func() (string, error) {
		if _, err := terraform.DestroyE(t, terraformOptions); err != nil {
			return "", fmt.Errorf("%s)", err)
		}
		return "", nil
	})

	services := []string{
		"harbor-harbor-chartmuseum",
		"harbor-harbor-clair",
		"harbor-harbor-core",
		"harbor-harbor-database",
		"harbor-harbor-jobservice",
		"harbor-harbor-portal",
		"harbor-harbor-redis",
		"harbor-harbor-registry",
		"harbor-harbor-trivy",
	}

	namespace := terraform.Output(t, terraformOptions, "namespace")

	options := k8s.NewKubectlOptions("", kubeconfig_file, namespace)
	for _, svc := range services {
		k8s.WaitUntilServiceAvailable(t, options, svc, 30, time.Second*10)
	}
}
