export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
skaffold run --kube-context kubernetes-admin@kubernetes --module common-tools

