# graphql-server-example

This is a demo for display graphql server as a app of knative

## Prerequisites

- [docker](https://www.docker.com/products/docker-desktop)
- [skaffold](https://skaffold.dev/docs/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Usage

start app and mysql service up

```bash
$ skaffold dev
...
```

get all serving components

```bash
$ kubectl get services.serving.knative.dev -A
NAMESPACE   NAME             URL                                              LATESTCREATED          LATESTREADY            READY   REASON
graphql     graphql-server   http://graphql-server.graphql.127.0.0.1.nip.io   graphql-server-00001   graphql-server-00001   True    
```

and then open browser with above url: <http://graphql-server.graphql.127.0.0.1.nip.io/graphql>

if there is no request for 30 seconds, knative will scale graphql-server to 0 until new request arrive
