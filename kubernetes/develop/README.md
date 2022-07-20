## https://rancher.management.servian.dev


# 2 - Setup Ingress, CertManager and Rancher

### Ingress Nginx 
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update
helm search repo ingress-nginx/ingress-nginx --versions


kubectl create namespace ingress-nginx

helm upgrade -i \
    ingress-nginx ingress-nginx/ingress-nginx \
    --namespace ingress-nginx \
    --version 4.1.1 \
    --set controller.nodeSelector.node_group=management \
    --set controller.autoscaling.enabled=true \
    --set controller.autoscaling.minReplicas=2 \
    --set defaultBackend.nodeSelector.node_group=management \
    --set controller.metrics.enabled=true \
    --set controller.stats.enabled=true \
    --set controller.admissionWebhooks.enabled=true \
    --set controller.ingressClass=nginx \
    --set controller.resources.requests.cpu=250m \
    --set controller.resources.requests.memory=512Mi \
    --set controller.resources.limits.cpu=1000m \
    --set controller.resources.limits.memory=2048Mi \
    --set defaultBackend.resources.limits.cpu=100m \
    --set defaultBackend.resources.limits.memory=128Mi \
    --set controller.service.type=LoadBalancer \
    --set controller.replicaCount=2 \
    --set defaultBackend.replicaCount=2
```


```
# helm upgrade --recreate-pods --wait --reuse-values ingress-nginx ingress-nginx/ingress-nginx
```

### Cert Manager
```
# Create the namespace for cert-manager
kubectl create namespace cert-manager

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install CRDs
# Install the CustomResourceDefinition resources separately
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.7.2/cert-manager.crds.yaml

# Install the cert-manager Helm v3 chart
helm upgrade -i \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.7.2 \
  --set resources.requests.cpu=100m \
  --set resources.requests.memory=128Mi \
  --set resources.limits.cpu=250m \
  --set resources.limits.memory=256Mi \
  --set nodeSelector.node_group=management \
  --set webhook.resources.requests.cpu=100m \
  --set webhook.resources.requests.memory=128Mi \
  --set webhook.resources.limits.cpu=250m \
  --set webhook.resources.limits.memory=256Mi \
  --set webhook.nodeSelector.node_group=management \
  --set cainjector.resources.requests.cpu=100m \
  --set cainjector.resources.requests.memory=128Mi \
  --set cainjector.resources.limits.cpu=250m \
  --set cainjector.resources.limits.memory=256Mi \
  --set cainjector.nodeSelector.node_group=management \
  --set installCRDs=true

kubectl apply -f ./prod_issuer.yaml
```

```
# helm upgrade -n cert-manager --wait --reuse-values cert-manager jetstack/cert-manager
```

### Rancher
```
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

kubectl create namespace cattle-system

nslookup <Check your DNS Rancher>

helm upgrade -i rancher rancher-stable/rancher \
    --namespace cattle-system \
    --set hostname=rancher.management.servian.com.br \
    --set replicas=2 \
    --version v2.6.5 \
    --set resources.requests.memory=2048Mi \
    --set resources.limits.memory=4096Mi \
    --set resources.requests.cpu=1000m \
    --set resources.limits.cpu=2000m \
    --set nodeSelector.node_group=management \
    --set ingress.tls.source=secret \
    --set ingress.extraAnnotations.'cert-manager\.io/cluster-issuer'=letsencrypt-prod

# To use letsEncrypt direct
    --set ingress.tls.source=letsEncrypt \
    --set letsEncrypt.email=atendimento@o2b.com.br \
    --set letsEncrypt.environment=production \
    --set letsEncrypt.ingress.class=nginx \
```
Solicitar a criação de DNS para as entradas: 

*.management.servian.com.br > 
*.homolog.servian.com.br > 

```

If this is the first time you installed Rancher, get started by running this command and clicking the URL it generates:

echo https://rancher.management.servian.com.br/dashboard/?setup=$(kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}')

```

To get just the bootstrap password on its own, run:

kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{ "\n" }}'

n5mks5tkzt8286kxvvxcwxtz5j97sjnncz48k8mb2qzkzr4qlb6h6r

```



```
# helm upgrade --namespace cattle-system --version v2.4.13 --reuse-values rancher rancher-stable/rancher
```

