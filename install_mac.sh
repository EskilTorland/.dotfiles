#!/bin/bash

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
  echo "Homebrew not found, installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew
echo "Updating Homebrew..."
brew update

# Install dependencies
echo "Installing dependencies..."

# Install iTerm2
brew install --cask iterm2

# Install zsh
brew install zsh

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Powerlevel10k theme
brew install powerlevel10k

# Install zsh-syntax-highlighting
brew install zsh-syntax-highlighting

# Install zsh-autosuggestions
brew install zsh-autosuggestions

# Install neovim
brew install neovim

# Install fzf
brew install fzf

# Install fd
brew install fd

# Install bat
brew install bat

# Install eza
brew install eza

# Install zoxide
brew install zoxide

# Clone fzf-git.sh repository
if [ ! -d "$HOME/fzf-git.sh" ]; then
  echo "Cloning fzf-git.sh repository..."
  git clone https://github.com/junegunn/fzf-git.sh.git ~/fzf-git.sh
fi

# Install Powerlevel10k recommended font
brew tap homebrew/cask
brew install --cask font-meslo-lg-nerd-font

PLUGINS_DIR="$HOME/.dotfiles/tmux/plugins"

brew install tmux

mkdir -p "$PLUGINS_DIR"

# install tmux plugin manager
if [ ! -d "$PLUGINS_DIR/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$PLUGINS_DIR/tpm"
fi

# Clone tmux-sensible plugin
if [ ! -d "$PLUGINS_DIR/tmux-sensible" ]; then
    git clone https://github.com/tmux-plugins/tmux-sensible "$PLUGINS_DIR/tmux-sensible"
fi


  # Install the plugins using TPM
  "$PLUGINS_DIR/tpm/bin/install_plugins"


# Provide instructions for setting the font in iTerm2
echo "Please set the font in iTerm2 to Meslo LG Nerd Font for best experience."
echo "Open iTerm2, go to Preferences > Profiles > Text, and set the font to Meslo LG Nerd Font."

echo "Installation and configuration completed!"

