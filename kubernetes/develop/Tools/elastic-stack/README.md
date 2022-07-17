

# Install Elastic Operator
```
kubectl create -f https://download.elastic.co/downloads/eck/1.9.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/1.9.0/operator.yaml
```

# Monitor the operator logs
```
kubectl -n elastic-system logs -f statefulset.apps/elastic-operator
```


