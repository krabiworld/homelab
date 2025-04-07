package resources

import (
	"base/structs"

	apps "k8s.io/api/apps/v1"
	core "k8s.io/api/core/v1"
	meta "k8s.io/apimachinery/pkg/apis/meta/v1"
)

func AddDeployment(m structs.Meta) *apps.Deployment {
	containerPorts := make([]core.ContainerPort, len(m.Hostnames))
	for i, hostname := range m.Hostnames {
		containerPorts[i] = core.ContainerPort{
			ContainerPort: hostname.Port,
		}
	}

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
			Template: core.PodTemplateSpec{
				ObjectMeta: meta.ObjectMeta{
					Labels: map[string]string{
						"app": m.Name,
					},
				},
				Spec: core.PodSpec{
					Containers: []core.Container{
						{
							Name:    m.Name,
							Image:   m.Image,
							Command: m.Command,
							Args:    m.Args,
							Ports:   containerPorts,
							Env:     m.Env,
						},
					},
				},
			},
		},
	}
}
