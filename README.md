# kubernetes-manifest
自身のenv(development/production)をレスポンスとして返すシンプルなwebサーバーと、それをKubernetesにデプロイするためのマニフェストを定義

## info
use tools
* [docker](https://www.docker.com/)
* [kubectl](https://kubernetes.io/ja/docs/tasks/tools/install-kubectl/)
* [kind](https://kind.sigs.k8s.io/)
* [helm](https://helm.sh/ja/)


## create kubernates cluster

### kubernates node setup in kind

development
```
kind create cluster --name development --config=kind/kind-development.yaml
```

production
```
kind create cluster --name production --config=kind/kind-production.yaml
```


### image create & upload
任意のレスポンスを返すためのコンテナを作成する。
ローカルのコンテナイメージを使用するため各kindクラスタにアップロードする。
（もっとスマートなやり方がある気がする）

```
docker build -t web-server web-server
kind load docker-image web-server --name development
kind load docker-image web-server --name production
```

## deploy

```
cd web-server
./deploy.sh development latest
./deploy.sh production latest
```

## accsess
```
# development
curl http://localhost:30079
# production
curl http://localhost:30070
```


## delete

kind cluster
```
kind delete cluster --name production
kind delete cluster --name development
```

docker image
```
docker image rm web-server
```
