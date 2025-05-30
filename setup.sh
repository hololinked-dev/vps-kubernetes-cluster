export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
kubectl apply -f cluster/manifests/yaml/kubernetes-dashboard-admin.yaml
skaffold run --module external-IP
skaffold run --module domain-tools
skaffold run --module kubernetes-dashboard

