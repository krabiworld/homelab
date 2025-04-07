package base

import (
	"base/resources"
	"base/structs"
	"encoding/json"
	"os"

	"github.com/yokecd/yoke/pkg/flight"
)

func Generate(m structs.Meta) {
	r := flight.Resources{}

	if len(m.VolumeSize) != 0 && len(m.Volumes) != 0 {
		r = append(r, resources.AddPersistentVolumeClaim(m))
	}

	if m.Stateful {
		r = append(r, resources.AddStatefulSet(m))
	} else {
		r = append(r, resources.AddDeployment(m))
	}

	r = append(r, resources.AddCertificate(m),
		resources.AddService(m),
		resources.AddGateway(m))

	for _, httpRoute := range resources.AddHTTPRoute(m) {
		r = append(r, httpRoute)
	}

	json.NewEncoder(os.Stdout).Encode(r)
}
