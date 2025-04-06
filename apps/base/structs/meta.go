package structs

import core "k8s.io/api/core/v1"

type Meta struct {
	Name      string
	Image     string
	Command   []string
	Args      []string
	Env       []core.EnvVar
	Hostnames []Hostname
}
