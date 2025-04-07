package resources

import (
	"base/structs"

	meta "k8s.io/apimachinery/pkg/apis/meta/v1"
	gw "sigs.k8s.io/gateway-api/apis/v1"
)

func AddHTTPRoute(m structs.Meta) []*gw.HTTPRoute {
	httpRoutes := make([]*gw.HTTPRoute, len(m.Hostnames))
	for i, hostname := range m.Hostnames {
		httpRoutes[i] = &gw.HTTPRoute{
			TypeMeta: meta.TypeMeta{
				APIVersion: gw.SchemeGroupVersion.Identifier(),
				Kind:       "HTTPRoute",
			},
			ObjectMeta: meta.ObjectMeta{
				Name:      m.Name,
				Namespace: m.Namespace,
			},
			Spec: gw.HTTPRouteSpec{
				CommonRouteSpec: gw.CommonRouteSpec{
					ParentRefs: []gw.ParentReference{
						{
							Name: gw.ObjectName(m.Name),
						},
					},
				},
				Hostnames: []gw.Hostname{gw.Hostname(hostname.DNSName)},
				Rules: []gw.HTTPRouteRule{
					{
						BackendRefs: []gw.HTTPBackendRef{
							{
								BackendRef: gw.BackendRef{
									BackendObjectReference: gw.BackendObjectReference{
										Name: gw.ObjectName(hostname.Name),
										Port: (*gw.PortNumber)(&hostname.Port),
									},
								},
							},
						},
					},
				},
			},
		}
	}

	return httpRoutes
}
