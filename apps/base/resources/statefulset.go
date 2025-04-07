package resources

import (
	"base/resources/helpers"
	"base/structs"

	apps "k8s.io/api/apps/v1"
	meta "k8s.io/apimachinery/pkg/apis/meta/v1"
)

func AddStatefulSet(m structs.Meta) *apps.StatefulSet {
	return &apps.StatefulSet{
		TypeMeta: meta.TypeMeta{
			APIVersion: apps.SchemeGroupVersion.Identifier(),
			Kind:       "StatefulSet",
		},
		ObjectMeta: meta.ObjectMeta{
			Name:      m.Name,
			Namespace: m.Namespace,
		},
		Spec: apps.StatefulSetSpec{
			Selector: &meta.LabelSelector{
				MatchLabels: map[string]string{
					"app": m.Name,
				},
			},
			Template: helpers.AddPodTemplateSpec(m),
		},
	}
}
