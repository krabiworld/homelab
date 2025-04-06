package base

import (
	"base/resources"
	"base/structs"
	"encoding/json"
	"os"

	"github.com/yokecd/yoke/pkg/flight"
)

func Generate(m structs.Meta) {
	r := flight.Resources{
		resources.AddCertificate(m),
		resources.AddDeployment(m),
		resources.AddService(m),
		resources.AddGateway(m),
	}

	for _, httpRoute := range resources.AddHTTPRoute(m) {
		r = append(r, httpRoute)
	}

	json.NewEncoder(os.Stdout).Encode(r)
}
