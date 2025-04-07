package main

import (
	"base"
	"base/structs"
)

func main() {
	base.Generate(structs.Meta{
		Name:      "minio",
		Namespace: "minio",
		Image:     "minio/minio:latest",
		Command: []string{
			"/bin/bash",
			"-c",
		},
		Args: []string{
			"minio server /data --console-address :9001",
		},
		Hostnames: []structs.Hostname{
			{
				Name:    "storage",
				DNSName: "*.storage.krabi.local",
				Port:    9000,
			},
			{
				Name:    "console",
				DNSName: "minio.krabi.local",
				Port:    9001,
			},
		},
	})
}
