#!/bin/bash

set -eu

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

echo "Installing Google Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome.deb
sudo gdebi --non-interactive /tmp/google-chrome.deb
rm /tmp/google-chrome.deb
echo "Ok"

# Install AWS Cli

if command -v aws &> /dev/null ; then
	echo "AWS CLI already installed"
else
	echo "Installing AWS CLI"
	aws_cli_installer=$(mktemp -d aws-cli-XXXX)
	cd $aws_cli_installer
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install
	cd -
	rm -rf $aws_cli_installer
	echo "AWS CLI installed"
fi

# Install AWS SAM Cli

echo "Installing AWS SAM CLI"
aws_sam_cli_installer=$(mktemp -d aws-sam-cli-XXXX)
cd $aws_sam_cli_installer
curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" -o "aws-sam-cli-linux-x86_64.zip"
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
sudo ./sam-installation/install
cd -
rm -rf $aws_sam_cli_installer
echo "AWS SAM CLI installed"

# Install kubectl CLI
echo "Installing kubectl CLI"
kubectl_installer=$(mktemp -d kubectl-cli-XXXX)
cd $kubectl_installer
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(<kubectl.sha256) kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
cd -
rm -rf $kubectl_installer
echo "kubectl CLI installed"

# Install kustomize CLI
echo "Installing kustomize CLI"
kustomize_installer=$(mktemp -d kustomize-cli-XXXX)
cd $kustomize_installer
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
sudo install -o root -g root -m 0755 kustomize /usr/local/bin/kustomize
cd -
rm -rf $kustomize_installer
echo "kustomize CLI installed"

# Install kapp CLI - https://carvel.dev/kapp/
echo "Installing kapp CLI"
kapp_installer=$(mktemp -d kapp-cli-XXXX)
cd $kapp_installer
curl -s -L "https://github.com/vmware-tanzu/carvel-kapp/releases/download/v0.40.0/kapp-linux-amd64" -o "kapp"
sudo install -o root -g root -m 0755 kapp /usr/local/bin/kapp
cd -
rm -rf $kapp_installer
echo "kapp CLI installed"

# Install Openshift CLI - https://github.com/openshift/origin/releases
echo "Installing oc (Openshift CLI)"
oc_installer=$(mktemp -d oc-cli-XXXX)
cd $oc_installer
curl -s -L "https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz" -o "oc.tar.gz"
echo "4b0f07428ba854174c58d2e38287e5402964c9a9355f6c359d1242efd0990da3 oc.tar.gz" | sha256sum --check
tar -xf "oc.tar.gz"
sudo install -o root -g root -m 0755 openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/local/bin/oc
cd -
rm -rf $oc_installer
echo "oc (Openshift CLI) installed"

# Install minikube CLI
echo "Installing minikube CLI"
minikube_installer=$(mktemp -d minikube-cli-XXXX)
cd $minikube_installer
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo install -o root -g root -m 0755 minikube /usr/local/bin/minikube
cd -
rm -rf $minikube_installer
echo "minikube CLI installed"

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
sudo apt install flameshot -y

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
	echo "apic CLI already installed"
else
    echo "Installing apic CLI"
    npm install -g apiconnect@5.2.12
    apic -v --accept-license --disable-analytics
    echo "Installed apic CLI"
fi
messages="${messages}\n\n\napic istalled on nvm. To use:\n"
messages="${messages}\$ nvm use v8.10.0 \n"
messages="${messages}\$ apic version"

# Install Angular CLI v9
nvm use v12.22.6
echo "Installing Angular CLI"
export NG_CLI_ANALYTICS=ci # Fix - no analytic question
npm install -g @angular/cli@9.1.14
echo "Installed Angular CLI"

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

echo "Finished Script"