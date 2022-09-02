#!/bin/bash

set -eu

RED='\e[1;91m'
GREEN='\e[1;92m'
NO_COLOR='\e[0m'

echo "Running script..."

#variables for collect messages to print after install
messages=""

# Basic tools
sudo apt install -y \
    openjdk-11-jdk \
    gdebi \
    wget \
    curl \
    libpam0g:i386 \
    libx11-6:i386 \
    libstdc++6:i386 \
    libstdc++5:i386 \
    libnss3-tools \
    gnome-tweaks
	

# Installing Google Chrome

echo -e "${GREEN}Installing Google Chrome${NO_COLOR}"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome.deb
sudo gdebi --non-interactive /tmp/google-chrome.deb
rm /tmp/google-chrome.deb
echo -e "${GREEN}Ok${NO_COLOR}"

# Install AWS Cli

if command -v aws &> /dev/null ; then
	echo -e "${GREEN}AWS CLI already installed${NO_COLOR}"
else
	echo -e "${GREEN}Installing AWS CLI${NO_COLOR}"
	aws_cli_installer=$(mktemp -d aws-cli-XXXX)
	cd $aws_cli_installer
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install
	cd -
	rm -rf $aws_cli_installer
	echo -e "${GREEN}AWS CLI installed${NO_COLOR}"
fi

# Install AWS SAM Cli

echo -e "${GREEN}Installing AWS SAM CLI${NO_COLOR}"
aws_sam_cli_installer=$(mktemp -d aws-sam-cli-XXXX)
cd $aws_sam_cli_installer
curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" -o "aws-sam-cli-linux-x86_64.zip"
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
sudo ./sam-installation/install
cd -
rm -rf $aws_sam_cli_installer
echo -e "${GREEN}AWS SAM CLI installed${NO_COLOR}"

# Install kubectl CLI
echo -e "${GREEN}Installing kubectl CLI${NO_COLOR}"
kubectl_installer=$(mktemp -d kubectl-cli-XXXX)
cd $kubectl_installer
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(<kubectl.sha256) kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
cd -
rm -rf $kubectl_installer
echo -e "${GREEN}kubectl CLI installed${NO_COLOR}"

# Install kustomize CLI
echo "Installing kustomize CLI"
kustomize_installer=$(mktemp -d kustomize-cli-XXXX)
cd $kustomize_installer
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
sudo install -o root -g root -m 0755 kustomize /usr/local/bin/kustomize
cd -
rm -rf $kustomize_installer
echo -e "${GREEN}kustomize CLI installed${NO_COLOR}"

# Install kapp CLI - https://carvel.dev/kapp/
echo -e "${GREEN}Installing kapp CLI${NO_COLOR}"
kapp_installer=$(mktemp -d kapp-cli-XXXX)
cd $kapp_installer
curl -s -L "https://github.com/vmware-tanzu/carvel-kapp/releases/download/v0.40.0/kapp-linux-amd64" -o "kapp"
sudo install -o root -g root -m 0755 kapp /usr/local/bin/kapp
cd -
rm -rf $kapp_installer
echo -e "${GREEN}kapp CLI installed${NO_COLOR}"

# Install Openshift CLI - https://github.com/openshift/origin/releases
echo -e "${GREEN}Installing oc (Openshift CLI)${NO_COLOR}"
oc_installer=$(mktemp -d oc-cli-XXXX)
cd $oc_installer
curl -s -L "https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz" -o "oc.tar.gz"
echo "4b0f07428ba854174c58d2e38287e5402964c9a9355f6c359d1242efd0990da3 oc.tar.gz" | sha256sum --check
tar -xf "oc.tar.gz"
sudo install -o root -g root -m 0755 openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/local/bin/oc
cd -
rm -rf $oc_installer
echo -e "${GREEN}oc (Openshift CLI) installed${NO_COLOR}"

# Install minikube CLI
echo -e "${GREEN}Installing minikube CLI${NO_COLOR}"
minikube_installer=$(mktemp -d minikube-cli-XXXX)
cd $minikube_installer
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo install -o root -g root -m 0755 minikube /usr/local/bin/minikube
cd -
rm -rf $minikube_installer
echo -e "${GREEN}minikube CLI installed${NO_COLOR}"

#Install Compass MongoDB
echo -e "${GREEN}Installing Compass MongoDB${NO_COLOR}"
wget https://downloads.mongodb.com/compass/mongodb-compass_1.32.3_amd64.deb /tmp/mongodb-compass.deb
sudo gdebi --non-interactive /tmp/mongodb-compass.deb
echo -e "${GREEN}Compass MongoDB Installed${NO_COLOR}"

# Install Dbeaver
flatpak install flathub io.dbeaver.DBeaverCommunity -y --noninteractive

flatpak install flathub com.spotify.Client -y --noninteractive

flatpak install flathub org.remmina.Remmina -y --noninteractive

flatpak install flathub us.zoom.Zoom -y --noninteractive

flatpak install flathub com.visualstudio.code -y --noninteractive

flatpak install flathub org.gnome.Boxes -y --noninteractive

flatpak install flathub com.microsoft.Teams -y --noninteractive

flatpak install flathub com.jetbrains.IntelliJ-IDEA-Community -y --noninteractive

flatpak install flathub org.gnome.meld -y --noninteractive

flatpak install flathub com.getpostman.Postman -y --noninteractive

flatpak install flathub com.rafaelmardojai.Blanket -y --noninteractive

flatpak install flathub com.transmissionbt.Transmission -y --noninteractive

flatpak install flathub org.onlyoffice.desktopeditors -y --noninteractive

#Installing flameshot
echo -e "${GREEN}Installing Flameshot${NO_COLOR}"
sudo apt install flameshot -y

#Installing Docker Engine
echo -e "${GREEN}Installing Docker Engine${NO_COLOR}"
sudo apt install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

#Manage Docker as a non-root user
echo -e "${GREEN}Manage Docker as a non-root user${NO_COLOR}"
sudo usermod -aG docker $USER

#Configure Docker to start on boot🔗
echo -e "${GREEN}Setting Docker to start on boot${NO_COLOR}"
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

echo -e "${GREEN}Docker Engine installed and configured${NO_COLOR}"

#Install Docker Containers
#Sonarqube
echo -e "${GREEN}Creating Sonarqube container${NO_COLOR}"
sudo docker run -d --name sonarqube -p 9001:9000 -v ~/work/docker/sonar/data:/opt/sonarqube/data -v ~/work/docker/sonar/logs:/opt/sonarqube/logs -v ~/work/docker/sonar/extensions:/opt/sonarqube/extensions sonarqube:8.9.9-community
echo "Sonarquebe launched${NO_COLOR}"

#MongoDB
echo -e "${GREEN}Creating MongoDB container"
sudo docker run --name mongoDB -d -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=mongoadmin -e MONGO_INITDB_ROOT_PASSWORD=secret -v ~/work/docker/mongo/data:/data/db mongo
echo -e "${GREEN}MongoDB launched${NO_COLOR}"

#ActiveMQ
echo "Creating ActiveMQ container"
sudo docker run --name activeMQ -p 61616:61616 -p 8161:8161 rmohr/activemq
echo -e "${GREEN}ActiveMQ launched${NO_COLOR}"

#Stopping Docker Containers
sudo docker stop sonarqube activeMQ mongoDB

# Install sdkman - https://sdkman.io
curl -s "https://get.sdkman.io" | bash
bash -c 'source "$HOME/.sdkman/bin/sdkman-init.sh"'

# Install Node Version Manager (nvm) - https://github.com/nvm-sh/nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# Install Openjdk 8
bash -c 'source $HOME/.sdkman/bin/sdkman-init.sh && sdk install java 8.0.302-open'
# Install Openjdk 11
bash -c 'source $HOME/.sdkman/bin/sdkman-init.sh && sdk install java 11.0.12-open'
# Install maven
bash -c 'source $HOME/.sdkman/bin/sdkman-init.sh && sdk install maven 3.6.3'

# Configure nvm for current shell
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Install node v12
nvm install v12.22.6

# Install node v8
nvm install v8.10.0

# Install apic
nvm use v8.10.0
if command -v apic &> /dev/null ; then
	echo -e "${GREEN}apic CLI already installed${NO_COLOR}"
else
    echo -e "${GREEN}Installing apic CLI${NO_COLOR}"
    npm install -g apiconnect@5.2.12
    apic -v --accept-license --disable-analytics
    echo -e "${GREEN}Installed apic CLI${NO_COLOR}"
fi
messages="${messages}\n\n\napic istalled on nvm. To use:\n"
messages="${messages}\$ nvm use v8.10.0 \n"
messages="${messages}\$ apic version"

# Install Angular CLI v9
nvm use v12.22.6
echo -e "${GREEN}Installing Angular CLI${NO_COLOR}"
export NG_CLI_ANALYTICS=ci # Fix - no analytic question
npm install -g @angular/cli@9.1.14
echo -e "${GREEN}Installed Angular CLI${NO_COLOR}"

# Configure NPM Auth Token
shell_rc="${HOME}/.bashrc"
if [[ "$(cat ${shell_rc} | grep -c NPM_AUTH_TOKEN)" -eq 0 ]]; then
	echo "Exporting NPM_AUTH_TOKEN to $shell_rc"
	echo -e "\n" >> $shell_rc
	echo "# Frota NPM Auth Token" >> $shell_rc
	echo "export NPM_AUTH_TOKEN=amVua2luczphYjJaR0x3KmJYISVeOHVNdEEzb2dw" >> $shell_rc
	messages="${messages}\n\nNPM_AUTH_TOKEN configured in $shell_rc. Please reopen this terminal"
else
	echo -e "NPM_AUTH_TOKEN already configured in $shell_rc : \n $(cat ${shell_rc} | grep NPM_AUTH_TOKEN)"
fi


echo "########################## Important ##########################"
echo -e "\n"
echo -e $messages
echo -e "\n\n"
echo "##############################################################"

echo -e "${GREEN}Finished Script${NO_COLOR}"