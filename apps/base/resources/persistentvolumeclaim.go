package resources

import (
	"base/structs"

	core "k8s.io/api/core/v1"
	"k8s.io/apimachinery/pkg/api/resource"
	meta "k8s.io/apimachinery/pkg/apis/meta/v1"
)

func AddPersistentVolumeClaim(m structs.Meta) *core.PersistentVolumeClaim {
	storageClassName := "longhorn"

	return &core.PersistentVolumeClaim{
		TypeMeta: meta.TypeMeta{
			APIVersion: core.SchemeGroupVersion.Identifier(),
			Kind:       "PersistentVolumeClaim",
		},
		ObjectMeta: meta.ObjectMeta{
			Name:      m.Name,
			Namespace: m.Namespace,
		},
		Spec: core.PersistentVolumeClaimSpec{
			AccessModes: []core.PersistentVolumeAccessMode{
				core.ReadWriteOnce,
			},
			Resources: core.VolumeResourceRequirements{
				Requests: core.ResourceList{
					"storage": resource.MustParse(m.VolumeSize),
				},
			},
			StorageClassName: &storageClassName,
		},
	}
}
