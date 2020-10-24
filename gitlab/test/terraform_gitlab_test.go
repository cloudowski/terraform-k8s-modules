package test

import (
	"os"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformGitlab(t *testing.T) {
	t.Parallel()

	kubeconfig_file := os.Getenv("KUBECONFIG")
	if len(kubeconfig_file) == 0 {
		kubeconfig_file = "~/.kube/config"
	}

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/gitlab/",
	}

	terraform.InitAndApply(t, terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	services := []string{
		"gitlab-gitaly",
		"gitlab-gitlab-exporter",
		"gitlab-gitlab-shell",
		"gitlab-minio-svc",
		"gitlab-postgresql",
		"gitlab-redis-master",
		"gitlab-webservice",
	}

	namespace := terraform.Output(t, terraformOptions, "namespace")

	options := k8s.NewKubectlOptions("", kubeconfig_file, namespace)
	for _, svc := range services {
		k8s.WaitUntilServiceAvailable(t, options, svc, 30, time.Second*10)
	}
}
