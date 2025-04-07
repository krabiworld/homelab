package helpers

import (
	"base/structs"

	core "k8s.io/api/core/v1"
	meta "k8s.io/apimachinery/pkg/apis/meta/v1"
)

func AddPodTemplateSpec(m structs.Meta) core.PodTemplateSpec {
	containerPorts := make([]core.ContainerPort, len(m.Hostnames))
	for i, hostname := range m.Hostnames {
		containerPorts[i] = core.ContainerPort{
			ContainerPort: hostname.Port,
		}
	}

	volumes := make([]core.Volume, len(m.Volumes))
	volumeMounts := make([]core.VolumeMount, len(m.Volumes))
	for i, volume := range m.Volumes {
		volumes[i] = core.Volume{
			Name: volume.Name,
			VolumeSource: core.VolumeSource{
				PersistentVolumeClaim: &core.PersistentVolumeClaimVolumeSource{
					ClaimName: m.Name,
				},
			},
		}

		volumeMounts[i] = core.VolumeMount{
			Name:      volume.Name,
			MountPath: volume.MountPath,
		}
	}

	return core.PodTemplateSpec{
		ObjectMeta: meta.ObjectMeta{
			Labels: map[string]string{
				"app": m.Name,
			},
		},
		Spec: core.PodSpec{
			Containers: []core.Container{
				{
					Name:         m.Name,
					Image:        m.Image,
					Command:      m.Command,
					Args:         m.Args,
					Ports:        containerPorts,
					Env:          m.Env,
					VolumeMounts: volumeMounts,
				},
			},
			Volumes: volumes,
		},
	}
}
