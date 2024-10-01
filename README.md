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

# Install Control Programs

```
paru -S blueman bluez pasystray redshift
```

# Install xsel and xclip

```
paru -S xsel xclip
```
# modify GRUB for more than one try

Note that I might not have to do this with systemd-boot.

### 1. Identify partitions

1.  List all block devices and their UUIDs:

```
        sudo blkid
```

2.  Locate the encrypted root partition (look for `TYPE="crypto_LUKS"`):

```
        /dev/nvme0n1p2: UUID="ecd1e246-475c-42d6-9681-70f2327859e0" TYPE="crypto_LUKS"
```

3.  Remove dashes from the UUID for use with GRUB:

```
        ecd1e246475c42d6968170f2327859e0
```

### 2. Create a Custom GRUB Script

1.  Create a new script in `/etc/grub.d/`:

```
        sudo nano /etc/grub.d/06_cryptodisk
```

2.  Add the following content to the script (replace the UUID with your
    own, without dashes):

```
        #!/bin/sh
        set -e

        cat << EOF
        insmod cryptodisk
        insmod luks
        cryptomount -u ecd1e246475c42d6968170f2327859e0 --tries=3
        EOF
```

3.  Make the script executable:

```
        sudo chmod +x /etc/grub.d/06_cryptodisk
```

### 3. Disable Default GRUB Cryptodisk Support

1.  Edit the GRUB configuration file:

```
        sudo nano /etc/default/grub
```

2.  Comment out the line enabling cryptodisk support:

```
        #GRUB_ENABLE_CRYPTODISK=y
```

This prevents GRUB from automatically adding default `cryptomount`
commands without the `--tries` option.

### 4. Regenerate the GRUB Configuration

Apply the changes by regenerating the `grub.cfg` file:

```
    sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### 5. Verify the Changes

1.  Open the new GRUB configuration file:

```
        sudo nano /boot/grub/grub.cfg
```

2.  Ensure the `cryptomount` command with `--tries=3` is present in the
    `06_cryptodisk` section:

```
        ### BEGIN /etc/grub.d/06_cryptodisk ###
        insmod cryptodisk
        insmod luks
        cryptomount -u ecd1e246475c42d6968170f2327859e0 --tries=3
        ### END /etc/grub.d/06_cryptodisk ###
```

3.  Confirm that there are no other `cryptomount` commands in the
    `10_linux` section.

### 6. Reboot and Test

1.  Reboot the system:

```
        sudo reboot
```

2.  During boot, test the multiple passphrase attempts:
    -   First attempt: Enter an incorrect passphrase.
    -   Second attempt: Enter an incorrect passphrase.
    -   Third attempt: Enter the correct passphrase.

3.  Verify that the system proceeds to boot after the correct passphrase
    is entered within three attempts.

## Additional Notes

-   Ensure that the UUID used in the custom script matches the UUID of
    your encrypted root partition, with dashes removed.
-   By disabling `GRUB_ENABLE_CRYPTODISK`, we prevent GRUB from adding
    conflicting default commands.
-   All changes are made to configuration files and scripts; avoid
    editing `/boot/grub/grub.cfg` directly, as it is auto-generated.
-   If you update GRUB or the system, you may need to revisit these
    configurations to ensure they are still in place.

## References

-   GRUB Manual:
    [https://www.gnu.org/software/grub/manual/grub/grub.html](https://www.gnu.org/software/grub/manual/grub/grub.html){target="_blank"}
-   ArchWiki on GRUB:
    [https://wiki.archlinux.org/title/GRUB](https://wiki.archlinux.org/title/GRUB){target="_blank"}
-   ArchWiki on Encrypted /boot:
    [https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#Encrypted\_/boot](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#Encrypted_/boot){target="_blank"}

