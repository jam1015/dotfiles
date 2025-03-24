# Dotfiles: Master

Dotfiles compatible across all my systems.

Hooks for version control are  in a [separate repo](https://www.github.com/jam1015/dots_hooks).  Clone that and run the setup script.



# Submodules

Include `--recurse submodules` or run `git submodule init` followed by `git submodule update --recursive`.

or go:

`git submodule update --recursive --remote`
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

```
paru -S zsh
```

- chsh to `zsh`

```
chsh -s /bin/zsh
```

# set up hooks

```
git clone git@github.com:jam1015/dots_hooks
```

run the hooks setup script from within.

```
cd ~/dots_hooks
./hooks_setup.bash
```

From dotfiles run the submodules setup script.

```
cd ~/dotfies
../dots_hooks/add_submodules.bash
```

# How to Remove yay and Install paru


```bash
sudo pacman -Rns yay
sudo pacman -S git
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

# Install from Package List

```
paru -S $(<arch-packages)
```

# Install NodeJS [superceded by package list]

 `sudo pacman -S nodejs npm`

# Font cache [partially superceded by package list]

`paru -S ttf-cm-unicode`

but remember to go:

`fc-cache -r`

# update grub

in `/etc/default/grub`

`GRUB_CMDLINE_LINUX="systemd.unit=multi-user.target"`


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

# or update systemd boot

in `/boot/loader/entries/xxxx`

```
title   Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=your-root-partition-uuid rw systemd.unit=multi-user.target
```

```
sudo systemctl disable lightdm.service
sudo systemctl set-default multi-user.target
```

# Install Control Programs [superseded by package list]

```
paru -S blueman bluez pasystray redshift
```

# Install xsel and xclip [superseded by package list]

```
paru -S xsel xclip
```

---




# hook for  package list iportant: outside of scope of dotfiles

`/etc/pacman.d/hooks/update-installed-packages-list.hook`



```
[Trigger]
Operation = Install
Operation = Upgrade
Operation = Remove
Type = Package
Target = *

[Action]
Description = Update list of installed packages
When = PostTransaction
Exec = /bin/bash -c 'pacman -Qq > "/home/jordan/dotfiles/arch-packages"'
```


# fix microphone

Edit `/usr/share/alsa-card-profile/mixer/paths/analog-input-internal-mic.conf` 


`[element Internal Mic Boost]` volume should be zero.
`[element Int Mic Boost]` volume should be zero.


# firefox full screen tabs


1.    Type about:config on Firefox address bar.
2.    Search for browser.fullscreen.autohide
3.    Set it to false


# github

1. `paru -S git-credential-manager-core`
2. `git config --global credential.helper manager-core`

The next time Git asks for your token, enter it once, and it will be securely remembered for future operations.


# timezone



Or, create a systemd service to update timezone on boot:

```zsh
sudoedit /etc/systemd/system/update-timezone.service
```

Add the following:

```
[Unit]
Description=Update system timezone based on location
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'timedatectl set-timezone "$(curl -s https://ipapi.co/timezone)"'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

Then enable the service:

```
sudo systemctl daemon-reload
sudo systemctl enable update-timezone.service
```

# R

I keep a list of packages I have installed in `/dotfiles/my_r_packs.r`
