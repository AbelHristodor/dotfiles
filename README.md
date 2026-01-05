# Dotfiles

## Prerequisites

- Homebrew (if on macOS)

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
```

- Oh-my-zsh

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Oh-my-zsh plugins

Here are a few suggested plugins to install for `oh-my-zsh`:

- Install `zsh-autosuggestions plugin`

```shell
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

- Install `fast-syntax-highlighting plugin`

```shell
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
```

## MacOS Setup

- Clone/Copy the `.zshrc` file
- Install all required packages:

```shell
brew install zsh
brew install git
brew install fzf
brew install tree
brew install eza
brew install neovim
brew install tmux
brew install starship
brew install mise
```

- Clone the `.config` dir into `~/.config`
- Finally source the `.zshrc` file: `source ~/.zshrc`

## Ubuntu/Debian Setup

- Clone/Copy the `.zshrc` file
- Install packages:

```shell
# Update package repositories
sudo apt-get update

# Install build essentials
sudo apt-get install -y curl wget build-essential

# Install core packages
sudo apt-get install -y zsh
sudo apt-get install -y git
sudo apt-get install -y tree
sudo apt-get install -y neovim
sudo apt-get install -y fzf
sudo apt-get install -y tmux

# Install eza
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt-get update
sudo apt-get install -y eza

# Install starship
curl -sS https://starship.rs/install.sh | sh
```

- Clone the `.config` dir into `~/.config`
- Finally source the `.zshrc` file: `source ~/.zshrc`
