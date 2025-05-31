# Self Managed Kubernetes in a Datacentre (VPS or Bare Metal)

Template repository that helps to autosetup VPS(-es) or nodes with Kubernetes.
Intended for porting the installation from one cloud provider to another, getting started with fullstack applications faster and automating the whole setup while doing so.

The following components can be installed:
- public facing load balancer
- kubernetes dashboard
- letsencrypt for SSL certificates
- plausible analytics (with databases)
- email server (mailcow)
- authentication manager (keycloak) (TODO)
- database (postgres or mongo) (TODO)
- docker registry (harbor) (TODO)
- helm charts for deploying custom applications by modifying image name, tags and environment variables
- skaffold for local development with file sync and deployment

## Setup

Add your SSH public key to the `authorized_keys` file on the VPS (Optional).

Create a dotenv file with environment variables as secrets:

```dotenv
MAIN_NODE_IP=<your vps ip>
MAIN_NODE_SSH_PORT=<your vps ssh port>
TOP_LEVEL_DOMAIN=<your domain example.com>
ADMIN_EMAIL=<your admin email >
PLAUSIBLE_PASSWORD=<your plausible password>
MAILCOW_ADMIN_PASSWORD=<your mailcow admin password>
KEYCLOAK_ADMIN_PASSWORD=<your keycloak admin password>
POSTGRES_PASSWORD=<your postgres password>
```

To install docker and kubernetes:

```bash
chmod +x install.sh
./install.sh docker
./install.sh kubernetes
sudo reboot
```

Ensure `cri-dockerd` (which is installed with docker install sequence) is working correctly before proceeding with Kubernetes setup.
Currently the version of `cri-dockerd` is not pinned, so it may change in the future. If you encounter issues, please check the [cri-dockerd repository](https://github.com/Mirantis/cri-dockerd.git). 

After installing Kubernetes, setup the cluster:

To export credentials: 
```bash
export KUBECONFIG=/etc/kubernetes/admin.conf
```

1) Remove node taint to allow scheduling of pods in the control plane node, if necessary (especially for single-node clusters):
```bash
kubectl taint nodes <node-name> node-role.kubernetes.io/control-plane:NoSchedule-
```

2) Install the Calico CNI plugin for networking:
```bash
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

3) To install all tools at once:

```bash
skaffold run
```

4) Adding nodes to the cluster (untested):
```bash
kubeadm token create --print-join-command
```
and run the command on the new node to join it to the cluster.

## Nodes Setup

#### Changing SSH port

Goto: 
```
nano /etc/ssh/sshd_config
```
and uncomment the port line and change it to your desired port, e.g. `Port 2222`.










