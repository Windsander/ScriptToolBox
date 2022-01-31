#!/bin/bash
docker pull quay.io/cephcsi/cephcsi:v3.4.0
docker pull k8s.gcr.io/sig-storage/csi-node-driver-registrar:v2.3.0
docker pull k8s.gcr.io/sig-storage/csi-resizer:v1.3.0
docker pull k8s.gcr.io/sig-storage/csi-provisioner:v3.0.0
docker pull k8s.gcr.io/sig-storage/csi-snapshotter:v4.2.0
docker pull k8s.gcr.io/sig-storage/csi-attacher:v3.3.0
