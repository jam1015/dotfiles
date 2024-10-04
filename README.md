# Dotfiles: Master

Dotfiles compatible across all my systems.
Hooks for version control are  in a [separate repo](https://www.github.com/jam1015/dots_hooks).  Clone that and run the setup script.

# Submodules

Include `--recurse submodules` or run `git submodule init` followed by `git submodule update --recursive`.

# set up ssh

```bash
        ssh-keygen -t ed25519 -C "jordan.mandel@live.com"
        #ssh-keygen -t rsa -b 4096 -C "jordan.mandel@live.com"
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_ed25519
        # if xclip is installed
        xclip -selection clipboard < ~/.ssh/id_ed25519.pub
```


# Things to do on install:

- Install `zsh`
- chsh to `zsh`


# How to Remove yay and Install paru


```bash
sudo pacman -Rns yay
sudo pacman -S git
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```


# Install NodeJS

 `sudo pacman -S nodejs npm`

# Font cache

`paru -S ttf-cm-unicoe`


`fc-cache -r`

# update grub

in `/etc/default/grub`

`GRUB_CMDLINE_LINUX="systemd.unit=multi-user.target"`

# or update systemd boot

in `/boot/loader/entries/xxxx`

```
title   Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=your-root-partition-uuid rw systemd.unit=multi-user.target
```

## BIOS Systems

`sudo grub-mkconfig -o /boot/grub/grub.cfg`

## UEFI Systems

`sudo grub-mkconfig -o /boot/efi/EFI/grub/grub.cfg`

# My preferred global Git config is included

Might also include:

```
git config --local submodule.recurse false
```

in this repo.

# Install Control Programs

```
paru -S blueman bluez pasystray redshift
```

# Install xsel and xclip

```
paru -S xsel xclip
```

# writing it out

```
sudo mkdir -p /etc/X11/xorg.conf.d
sudo nano /etc/X11/xorg.conf.d/20-intel.conf
```


```
Section "Device"
    Identifier  "Intel Graphics"
    Driver      "intel"
    Option      "TearFree" "true"
EndSection
```

