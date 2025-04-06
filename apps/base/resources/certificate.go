package resources

import (
	"base/structs"
	"fmt"

	cm "github.com/cert-manager/cert-manager/pkg/apis/certmanager/v1"
	cmmeta "github.com/cert-manager/cert-manager/pkg/apis/meta/v1"
	meta "k8s.io/apimachinery/pkg/apis/meta/v1"
)

func AddCertificate(m structs.Meta) *cm.Certificate {
	dnsNames := make([]string, len(m.Hostnames))
	for i, hostname := range m.Hostnames {
		dnsNames[i] = hostname.DNSName
	}

	return &cm.Certificate{
		TypeMeta: meta.TypeMeta{
			APIVersion: cm.SchemeGroupVersion.Identifier(),
			Kind:       "Certificate",
		},
		ObjectMeta: meta.ObjectMeta{
			Name: fmt.Sprintf("%s-cert", m.Name),
		},
		Spec: cm.CertificateSpec{
			SecretName: fmt.Sprintf("%s-tls", m.Name),
			DNSNames:   []string{},
			IssuerRef: cmmeta.ObjectReference{
				Name: "selfsigned-issuer",
				Kind: "ClusterIssuer",
			},
		},
	}
}
