# graphql-server-example

This is a demo for display graphql server as a app of knative

## Prerequisites

- [docker](https://www.docker.com/products/docker-desktop)
- [skaffold](https://skaffold.dev/docs/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Usage

start customer service up

```bash
$ skaffold dev
...
```

test channel is available

```bash
$ kubectl run --image yauritux/busybox-curl busybox -- curl -v "http://cloudevent-kn-channel.cloudevent.svc.cluster.local" -X POST -H "Ce-Id: say-hello" -H "Ce-Specversion: 1.0" -H "Ce-Type: greeting" -H "Ce-Source: not-sendoff" -H "Content-Type: application/json" -d '{"msg":"Hello Knative!"}'
```

and then display logs of hello-display

```bash
$ kubectl logs -n cloudevent -l app=hello-display
Context Attributes,
  specversion: 1.0
  type: greeting
  source: not-sendoff
  id: say-hello
  datacontenttype: application/json
Data,
  {
    "msg": "Hello Knative!"
  }
```