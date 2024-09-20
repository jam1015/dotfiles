# Dotfiles: Master
Dotfiles compatible across all my systems.
Hooks controlled in a [separate repo](https://www.github.com/jam1015/dots_hooks)  Clone that and run the setup script.
Hopefully this also works on Nix.


# Things to do on install:

- Install `zsh`
- chsh to `zsh`

# Install other config


 Found [here](https://github.com/jam1015/other_config)

# How to Remove yay and Install paru

## Step 1: Remove yay

First, remove yay using pacman:

`sudo pacman -Rns yay`

## Step 2: Install Git

If you don\'t have Git installed, install it:

`sudo pacman -S git`

## Step 3: Clone paru repository

Clone the paru repository from GitHub:

`git clone https://aur.archlinux.org/paru.git`

## Step 4: Navigate to paru directory

`cd paru`

## Step 5: Build and install paru

Build and install paru using makepkg:

`makepkg -si`

## Step 6: Verify installation

Verify that paru is installed correctly:

`paru --version`

You have now successfully removed yay and installed paru as your AUR
helper.

# Install NodeJS

 `sudo pacman -S nodejs npm`
