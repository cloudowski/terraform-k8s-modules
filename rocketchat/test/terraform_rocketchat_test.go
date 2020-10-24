package test

import (
	"os"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformJenkins(t *testing.T) {
	t.Parallel()

	kubeconfig_file := os.Getenv("KUBECONFIG")
	if len(kubeconfig_file) == 0 {
		kubeconfig_file = "~/.kube/config"
	}

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/rocketchat/",
	}

	terraform.InitAndApply(t, terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	namespace := terraform.Output(t, terraformOptions, "namespace")

	options := k8s.NewKubectlOptions("", kubeconfig_file, namespace)
	k8s.WaitUntilServiceAvailable(t, options, "rocketchat-rocketchat", 30, time.Second*10)
	k8s.WaitUntilServiceAvailable(t, options, "rocketchat-mongodb", 30, time.Second*10)

}
