package resources

import (
	"base/structs"
	"fmt"

	meta "k8s.io/apimachinery/pkg/apis/meta/v1"
	gw "sigs.k8s.io/gateway-api/apis/v1"
)

func AddGateway(m structs.Meta) *gw.Gateway {
	fromNamespace := gw.FromNamespaces("Same")

	listeners := make([]gw.Listener, len(m.Hostnames))
	for i, hostname := range m.Hostnames {
		listener := gw.Listener{
			Name:     gw.SectionName(fmt.Sprintf("%s-https", hostname.Name)),
			Port:     gw.PortNumber(hostname.Port),
			Protocol: gw.HTTPSProtocolType,
			Hostname: (*gw.Hostname)(&hostname.DNSName),
			TLS: &gw.GatewayTLSConfig{
				CertificateRefs: []gw.SecretObjectReference{
					{
						Name: gw.ObjectName(fmt.Sprintf("%s-tls", m.Name)),
					},
				},
			},
			AllowedRoutes: &gw.AllowedRoutes{
				Namespaces: &gw.RouteNamespaces{
					From: &fromNamespace,
				},
			},
		}

		listeners[i] = listener
	}

	return &gw.Gateway{
		TypeMeta: meta.TypeMeta{
			APIVersion: gw.SchemeGroupVersion.Identifier(),
			Kind:       "Gateway",
		},
		ObjectMeta: meta.ObjectMeta{
			Name: fmt.Sprintf("%s-gateway", m.Name),
		},
		Spec: gw.GatewaySpec{
			GatewayClassName: "istio",
			Listeners:        listeners,
		},
	}
}
