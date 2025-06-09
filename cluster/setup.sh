export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
kubectl apply -f cluster/manifests/yaml/kubernetes-dashboard-admin.yaml
skaffold run --module external-load-balancer
skaffold run --module cert-manager
skaffold run --module kubernetes-dashboard

