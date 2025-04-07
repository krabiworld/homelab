package resources

import (
	"base/structs"

	core "k8s.io/api/core/v1"
	meta "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/util/intstr"
)

func AddService(m structs.Meta) *core.Service {
	servicePorts := make([]core.ServicePort, len(m.Hostnames))
	for i, hostname := range m.Hostnames {
		servicePorts[i] = core.ServicePort{
			Name:       hostname.Name,
			Port:       hostname.Port,
			TargetPort: intstr.FromInt32(hostname.Port),
		}
	}

	return &core.Service{
		TypeMeta: meta.TypeMeta{
			APIVersion: core.SchemeGroupVersion.Identifier(),
			Kind:       "Service",
		},
		ObjectMeta: meta.ObjectMeta{
			Name:      m.Name,
			Namespace: m.Namespace,
		},
		Spec: core.ServiceSpec{
			Selector: map[string]string{
				"app": m.Name,
			},
			Ports: servicePorts,
		},
	}
}
