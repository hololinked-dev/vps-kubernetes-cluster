#!/bin/sh

if [ "$1" = "docker" ]; then
  # Add Docker's official GPG key:
  sudo apt-get update
  sudo apt-get install -y ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update

  # Install docker packages:
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  # cri-dockerd installation as docker still does not support CRI natively:
  sudo apt-get install -y git golang-go
  git clone https://github.com/Mirantis/cri-dockerd.git
  cd cri-dockerd
  go build -o cri-dockerd
  sudo mv cri-dockerd /usr/bin/

  sudo cp packaging/systemd/cri-docker.service /etc/systemd/system/
  sudo cp packaging/systemd/cri-docker.socket  /etc/systemd/system/
  sudo systemctl daemon-reload
  sudo systemctl enable --now cri-docker.socket

  # Test Docker installation:
  sudo docker run hello-world

elif [ "$1" = "kubernetes" ]; then

  # Kubernetes installation with kubeadm:
  sudo apt-get update
  sudo apt-get install -y apt-transport-https ca-certificates curl gpg
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
  sudo apt-get install -y kubelet kubeadm kubectl
  sudo apt-mark hold kubelet kubeadm kubectl
  sudo systemctl enable --now kubelet

  # Install helm and skaffold:
  curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
  curl -s https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 -o skaffold
  sudo install skaffold /usr/local/bin/

  wget https://github.com/derailed/k9s/releases/download/v0.50.6/k9s_linux_amd64.deb
  # update version number when new release is available - https://github.com/derailed/k9s/releases
  sudo dpkg -i k9s_linux_amd64.deb
  rm k9s_linux_amd64.deb
  sudo apt-get -y install socat # port forwarding


elif [ "$1" = "mailcow" ]; then

  # Mailcow installation:
  sudo apt-get update
  cd /opt
  git clone https://github.com/mailcow/mailcow-dockerized
  cd /opt/mailcow-dockerized/
  sudo ./generate_config.sh
  sudo docker compose pull
  sudo docker compose up -d
  echo "Mailcow installation complete. Make sure to add DNS records as specified here: https://docs.mailcow.email/getstarted/prerequisite-dns/#the-minimal-dns-configuration"
  cd ~/

else
  echo "Usage: $0 {docker|kubernetes|mailcow}"
  exit 1
fi
