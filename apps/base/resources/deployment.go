package resources

import (
	"base/resources/helpers"
	"base/structs"

	apps "k8s.io/api/apps/v1"
	meta "k8s.io/apimachinery/pkg/apis/meta/v1"
)

func AddDeployment(m structs.Meta) *apps.Deployment {
	return &apps.Deployment{
		TypeMeta: meta.TypeMeta{
			APIVersion: apps.SchemeGroupVersion.Identifier(),
			Kind:       "Deployment",
		},
		ObjectMeta: meta.ObjectMeta{
			Name:      m.Name,
			Namespace: m.Namespace,
		},
		Spec: apps.DeploymentSpec{
			Selector: &meta.LabelSelector{
				MatchLabels: map[string]string{
					"app": m.Name,
				},
			},
			Template: helpers.AddPodTemplateSpec(m),
		},
	}
}
