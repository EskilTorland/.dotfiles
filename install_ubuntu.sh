#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Update package list and upgrade packages
echo "Updating package list and upgrading packages..."
sudo apt update && sudo apt upgrade -y

# Install dependencies
echo "Installing dependencies..."

# Install Zsh
if ! command_exists zsh; then
  sudo apt install -y zsh
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Install zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Install zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Install Neovim
if ! command_exists nvim; then
  sudo apt install -y neovim
fi

# Install fzf
if ! command_exists fzf; then
  sudo apt install -y fzf
fi

# Install fd
if ! command_exists fd; then
  sudo apt install -y fd-find
  sudo ln -s $(which fdfind) /usr/local/bin/fd  # Create a symlink to make fd available as 'fd'
fi

# Install bat
if ! command_exists bat; then
  sudo apt install -y bat
  sudo ln -s /usr/bin/batcat /usr/local/bin/bat  # Create a symlink to make bat available as 'bat'
fi

# Install eza
if ! command_exists eza; then
  sudo apt install -y exa
fi

# Install zoxide
if ! command_exists zoxide; then
  curl -sS https://webinstall.dev/zoxide | bash
fi

# Clone fzf-git.sh repository
if [ ! -d "$HOME/fzf-git.sh" ]; then
  echo "Cloning fzf-git.sh repository..."
  git clone https://github.com/junegunn/fzf-git.sh.git ~/fzf-git.sh
fi

# Install Powerlevel10k recommended font
if ! command_exists fc-list | grep -qi "MesloLGS NF"; then
  echo "Installing Meslo LG Nerd Font..."
  mkdir -p ~/.local/share/fonts
  cd ~/.local/share/fonts && curl -fLo "MesloLGS NF Regular.ttf" https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip && unzip Meslo.zip && rm Meslo.zip
  fc-cache -fv
fi

# Provide instructions for setting the font in terminal
echo "Please set the font in your terminal to MesloLGS NF for best experience."
echo "Open your terminal settings and set the font to MesloLGS NF."
echo "Open your terminal settings and set the shell to /bin/zsh"

# Reload zsh configuration to apply changes
echo "Reloading zsh configuration..."
source ~/.zshrc

echo "Installation and configuration completed!"

