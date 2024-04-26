#!/bin/bash

# Install the required packages

# install wezterm
curl -LO https://github.com/wez/wezterm/releases/download/20240203-110809-5046fc22/WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage
chmod +x WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage

mv mv ./WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage /usr/local/bin/wezterm

#### Basic Utilities ####
# Git: https://git-scm.com/download/linux
sudo apt-get install -y git

# Zsh: https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH
sudo apt install zsh just -y

# Flameshot: https://flameshot.org/getting-started/
sudo apt install flameshot -y

# Ranger
sudo apt install ranger -y

# Oh My Zsh: https://ohmyz.sh/#install
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# ZSH-Autosuggestions: https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# ZSH-Syntax-Highlighting: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Poetry
curl -sSL https://install.python-poetry.org | python3 -

# Poetry completions
mkdir $ZSH_CUSTOM/plugins/poetry
poetry completions zsh > $ZSH_CUSTOM/plugins/poetry/_poetry

# Poetry-env
curl -L git.io/Jinm5 > poetry.zsh
source poetry.zsh

# Pyenv: https://github.com/pyenv/pyenv?tab=readme-ov-file#unixmacos
curl https://pyenv.run | bash

# Exa: https://the.exa.website/install/linux
apt install exa -y

# Tmux's TPM Plugin Manager:
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

## Hit `prefix + I` to fetch the plugins


#### Neovim ####
# Ripgrep: https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
dpkg -i ripgrep_13.0.0_amd64.deb

# Neovim: https://github.com/neovim/neovim/wiki
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

# Lazygit: https://github.com/jesseduffield/lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin


#### Kubernetes ####
# Kubectl: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Krew - Kubectl Plugin Manager: https://krew.sigs.k8s.io/docs/user-guide/setup/install/
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)

# Kubectx: https://github.com/ahmetb/kubectx?tab=readme-ov-file#kubectl-plugins-macos-and-linux
kubectl krew install ctx
kubectl krew install ns

# Stern: https://github.com/stern/stern
kubectl krew install stern

# Kubecolor: https://github.com/hidetatz/kubecolor/releases
curl -LO https://github.com/hidetatz/kubecolor/releases/download/v0.0.25/kubecolor_0.0.25_Linux_x86_64.tar.gz
tar -xvf kubecolor_0.0.25_Linux_x86_64.tar.gz
chmod +x kubecolor
sudo mv kubecolor /usr/local/bin/kubecolor

# K9s: https://k9scli.io/topics/install/
curl -LO https://github.com/derailed/k9s/releases/download/v0.31.9/k9s_Linux_amd64.tar.gz
tar -xvf k9s_Linux_amd64.tar.gz
chmod +x k9s
sudo mv k9s /usr/local/bin/k9s

# Popeye: https://popeyecli.io/
curl -LO https://github.com/derailed/popeye/releases/download/v0.11.3/popeye_Linux_amd64.tar.gz
tar -xvf popeye_Linux_amd64.tar.gz
chmod +x popeye
sudo mv popeye /usr/local/bin/popeye

# Df-pv: https://github.com/yashbhutwala/kubectl-df-pv
kubectl krew install df-pv

#### Node ####
# NVM: https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash


#### Gcloud ####
# Gcloud: https://cloud.google.com/sdk/docs/install
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-464.0.0-linux-x86_64.tar.gz
tar -xvf google-cloud-cli-464.0.0-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh
