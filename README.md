# kind-knative-terraform

This is demo enviroment of knative, and it is refer to https://github.com/csantanapr/knative-kind, but use nats-streaming as component of eventing instead of in-memory

## Prerequisites
- [terraform](https://www.terraform.io/downloads.html)
- [docker](https://www.docker.com/products/docker-desktop) or [podman](https://podman.io/getting-started/installation)
- [kind](https://kind.sigs.k8s.io/docs/user/quick-start#installation)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [helm](https://helm.sh/docs/intro/install/)

## Usage
initialize terraform module
```bash
$ terraform init
```
launch knative enviroment at kind cluster
```bash
$ terraform apply -auto-approve
```
List all pods from kind cluster
```bash
$ kubectl get pods -A
NAMESPACE            NAME                                            READY   STATUS    RESTARTS   AGE
knative-eventing     eventing-controller-658f454d9d-kj8wd            1/1     Running   0          69s
knative-eventing     eventing-webhook-69fdcdf8d4-tbmfr               1/1     Running   0          69s
knative-eventing     natss-ch-controller-55cb87c66f-d8lsh            1/1     Running   0          23s
knative-eventing     natss-ch-dispatcher-846bb5846b-tvbqf            1/1     Running   0          23s
knative-eventing     natss-webhook-7d7f99b9d6-lq5th                  1/1     Running   0          23s
knative-serving      3scale-kourier-control-94d88747c-hnxcv          1/1     Running   0          103s
knative-serving      activator-85cd6f6f9-hvrkv                       1/1     Running   0          2m13s
knative-serving      autoscaler-7959969587-tjw7k                     1/1     Running   0          2m13s
knative-serving      controller-577558f799-gckq4                     1/1     Running   0          2m13s
knative-serving      webhook-78f446786-ghzzz                         1/1     Running   0          2m13s
kourier-system       3scale-kourier-gateway-6577686f94-x4vnz         1/1     Running   0          103s
kube-system          coredns-74ff55c5b-8zbcb                         1/1     Running   0          2m38s
kube-system          coredns-74ff55c5b-lhww5                         1/1     Running   0          2m38s
kube-system          etcd-knative-control-plane                      1/1     Running   0          2m50s
kube-system          kindnet-q7ccs                                   1/1     Running   0          2m37s
kube-system          kube-apiserver-knative-control-plane            1/1     Running   0          2m50s
kube-system          kube-controller-manager-knative-control-plane   1/1     Running   0          2m50s
kube-system          kube-proxy-hl6n4                                1/1     Running   0          2m37s
kube-system          kube-scheduler-knative-control-plane            1/1     Running   0          2m49s
local-path-storage   local-path-provisioner-78776bfc44-82ggh         1/1     Running   0          2m38s
natss                nats-streaming-0                                2/2     Running   0          49s
```
destroy kind cluster
```bash
$ terraform destroy -auto-approve
```