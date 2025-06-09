# Self Managed Kubernetes in a Datacentre (VPS or Bare Metal)

Template repository that helps to autosetup VPS(-es) or nodes with Kubernetes.
Intended for getting started with fullstack applications faster, porting the installation from one cloud provider to another and automating the whole setup while doing so.

The following components can be installed:
- public facing load balancer
- kubernetes dashboard
- letsencrypt for SSL certificates
- plausible analytics
- email server (mailcow) (outside kubernetes - intended to be used in a separate node/machine)
- authentication manager (keycloak) (TODO)
- database (postgres or mongo) (TODO)
- docker registry (harbor) (TODO)
- helm charts for deploying custom applications by modifying image name, tags and environment variables

## Setup

Add your SSH public key to the `authorized_keys` file on the VPS (Optional).

Create a dotenv file with environment variables as secrets:

```dotenv
MAIN_NODE_IP=<your vps ip>
MAIN_NODE_SSH_PORT=<your vps ssh port>
TOP_LEVEL_DOMAIN=<your domain example.com>
ADMIN_EMAIL=<your admin email >
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

## Installing Specific Components

| Component                | Installation Command                           | Notes                                        |
|--------------------------|------------------------------------------------|----------------------------------------------|
| External Load Balancer   | `skaffold run --module external-load-balancer` |                                              |
| Kubernetes Dashboard     | `skaffold run --module kubernetes-dashboard`   |                                              |
| SSL (Let's Encrypt)      | `skaffold run --module cert-manager`           |                                              |
| mailcow (Email Server)   | `./install.sh mailcow`                         | Outside Kubernetes, intended for a separate node machine as it will expose its own server |
| Plausible Analytics      | `skaffold run --module plausible-analytics`    | Not fully ready yet, does not work correctly |
| Keycloak (Auth Manager)  | `skaffold run --module keycloak`               | TODO, see issues                             |
| Postgres Database        | `skaffold run --module postgres`               | TODO, see issues                             |
| Mongo Database           | `skaffold run --module mongo`                  | TODO                                         |
| Harbor (Docker Registry) | `skaffold run --module harbor`                 | TODO, see issues                             |

## Skaffold

To use this repository with skaffold, see examples here:

- [material mkdocs documentation](https://github.com/hololinked-dev/docs-v2)

Essentially,

1. submodule this repository into your project
2. create a `skaffold.yaml` file in your project root
3. Use the helm charts:
    - `cluster/manifests/helm/apps` for your app
    - `cluster/manifests/helm/ingress` for an ingress
4. If you need an ingress controller apart from the public facing load balancer, you could change the ingress class name in the `skaffold.yaml` file. 
5. Integrate skaffold in your pipeline and do `skaffold build` for building the images and `skaffold deploy` for deploying them.

`skaffold-apps.yaml` and `apps` folder will be removed in the future, as they are not needed anymore.

## Nodes Setup

#### Changing SSH port

Goto: 
```
nano /etc/ssh/sshd_config
```
and uncomment the port line and change it to your desired port, e.g. `Port 2222`.










