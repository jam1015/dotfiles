# Dotfiles

Dotfiles shared across all my Arch systems, installed into `~` with
[GNU Stow](https://www.gnu.org/software/stow/). Version-control hooks live in a
[separate repo](https://github.com/jam1015/dots_hooks).

# Fresh install

Do these in order on a new machine; each step links to its details below.

1. [Install git and paru](#install-paru)
2. [Create an SSH key and add it to GitHub](#ssh-key)
3. [Clone this repo with submodules](#clone-and-submodules)
4. [Stow the dotfiles into `~`](#stow)
5. [Install the package list](#install-the-package-list)
6. [Set up the git hooks](#git-hooks)
7. [Switch the login shell to zsh](#shell)
8. [Set up gopass for Git credentials](#credential-helper-gopass)
9. Optional: [pacman hook](#pacman-hook-for-the-package-list),
   [boot to a console](#boot-to-a-console),
   [console font](#console-tty-font),
   [machine-specific fixes](#machine-specific-fixes)

# Install paru

If yay is installed, remove it first with `sudo pacman -Rns yay`. Then:

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

# GitHub access

## SSH key

```bash
ssh-keygen -t ed25519 -C "jordan.mandel@live.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
# copy the public key, then paste it into GitHub > Settings > SSH keys
wl-copy < ~/.ssh/id_ed25519.pub                      # Wayland (wl-clipboard)
xclip -selection clipboard < ~/.ssh/id_ed25519.pub   # X11 (or: xsel -ib)
cat ~/.ssh/id_ed25519.pub                            # bare tty: print and copy by hand
```

## Credential helper (gopass)

The tracked `.gitconfig` already sets `helper = gopass`, so after stowing you
only need to install and initialize it:

```bash
paru -S gopass git-credential-gopass
gopass init
git config --global --get credential.helper   # should print: gopass
```

The next time Git asks for your token, enter it once and gopass will store it.

# Clone and submodules

```bash
git clone --recurse-submodules git@github.com:jam1015/dotfiles ~/dotfiles
```

If you cloned without `--recurse-submodules`:

```bash
git submodule update --init --recursive
```

That checks out the commits pinned in this repo. To move every submodule to
its latest upstream commit instead, add `--remote`; the pinned commits then
change, so commit the result.

If a submodule URL in `.gitmodules` changes, run `git submodule sync --recursive`
to copy the new URLs into `.git`.

Don't set `submodule.recurse = true` for this repo. With it on, `git pull`,
`checkout`, `switch` and `reset` also move every submodule back to the commit
pinned here. Most of these submodules update themselves (oh-my-zsh's updater,
`doom upgrade`, spacemacs tracking `develop`, tpm), so recursing would keep
undoing those updates and make every pull slower. It's off by default; if
your global git config turns it on, override it for this repo only:

```bash
git config --local submodule.recurse false
```

# Stow

From inside the repo, symlink everything into `~`:

```bash
cd ~/dotfiles
stow .
```

Stow targets the parent directory by default, which is `~` as long as the repo
lives at `~/dotfiles`. `.stow-local-ignore` keeps repo-only files out of `~`,
including this README, `etc/`, `.scripts`, `arch-packages` and the R package
lists.

If stow reports conflicts, files with those names already exist in `~`. Move
or delete them and run `stow .` again. To keep the existing versions instead,
run `stow --adopt .`, which moves them into the repo; check `git diff` before
committing.

# Packages

## Install the package list

```bash
paru -S --needed - < ~/dotfiles/arch-packages
```

`arch-packages` is written by the [pacman hook](#pacman-hook-for-the-package-list).

After installing fonts, rebuild the font cache:

```bash
fc-cache -r
```

## Pacman hook for the package list

This file lives outside the repo, at
`/etc/pacman.d/hooks/update-installed-packages-list.hook`:

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
Exec = /bin/bash -c 'pacman -Qqe > "$(getent passwd 1000 | cut -d: -f6)/dotfiles/arch-packages"'
```

`pacman -Qqe` records only explicitly installed packages, not their
dependencies. This matters on a reinstall: everything installed from the list
gets marked as explicitly installed. If the list included dependencies, they
would all become "explicit" too, and pacman would never treat them as
orphans, even after nothing needs them. Keeping dependencies out of the list
means they're reinstalled as dependencies, so this still finds and removes
unneeded ones:

```bash
sudo pacman -Rns $(pacman -Qdtq)   # remove orphaned dependencies
```

It also keeps the list short and avoids install failures from dependencies
that have since been dropped from the repos.

Pacman hooks run as root, so `~` and `$HOME` would point at `/root`. The
command looks up the home directory of the first regular user (UID 1000)
instead of hardcoding a username. If your UID differs, check it with `id -u`.

> **One-time migration:** older copies of `arch-packages` were made with
> `pacman -Qq` and include every dependency. On your main machine, regenerate
> it once with `pacman -Qqe > ~/dotfiles/arch-packages` and commit it.

## R

The list of R packages I use is in `~/dotfiles/my_r_packs.r`.

## Lisp

```bash
paru -S sbcl quicklisp
sbcl --load /usr/share/quicklisp/quicklisp.lisp --eval '(quicklisp-quickstart:install)' --quit
sbcl --load ~/quicklisp/setup.lisp --eval '(ql:add-to-init-file)' --quit
```

# Git hooks

```bash
git clone git@github.com:jam1015/dots_hooks ~/dots_hooks
cd ~/dots_hooks
./hooks_setup.bash
```

Only if the hooks didn't set up the submodules properly:

```bash
cd ~/dotfiles
../dots_hooks/add_submodules.bash
```

# Shell

```bash
paru -S --needed zsh
chsh -s /bin/zsh
```

# Boot to a console

This makes the system boot to a text console instead of a graphical login
screen. Disable whichever display manager is enabled (lightdm, sddm,
plasma-login-manager, ...); `display-manager.service` is an alias for the
active one. Then make the text-mode target the default:

```bash
sudo systemctl disable display-manager.service
sudo systemctl set-default multi-user.target
```

No bootloader changes are needed. After logging in on the console, start a
graphical session by hand:

```bash
startx              # X11: runs ~/.xinitrc (i3, bspwm, ...)
Hyprland            # Wayland compositors are launched directly
river
startplasma-wayland # KDE Plasma on Wayland (X11: put startplasma-x11 in ~/.xinitrc)
```

To go back to a graphical login screen, re-enable your display manager by
name and restore the graphical target:

```bash
sudo systemctl enable sddm.service   # or lightdm.service, etc.
sudo systemctl set-default graphical.target
```

# Console (tty) font

This is separate from GUI fonts: the bare tty (Ctrl+Alt+F3) uses PSF fonts
under `/usr/share/kbd/consolefonts/`. A tracked copy of `/etc/vconsole.conf`
lives at `etc/vconsole.conf` in this repo and is installed by
`.scripts/install_console_font.bash` (invoked from `hooks_setup.bash`). Edit
the tracked file and re-run the hook (needs sudo); it copies the file to
`/etc/vconsole.conf` and applies `setfont` to active ttys.

The default is `FONT=ter-v22n`, which needs the `terminus-font` package;
built-in fallbacks include `lat2-16` and `lat9w-16`. List available fonts with
`ls /usr/share/kbd/consolefonts/` (omit the extension). Preview them in a GUI
with `python3 ~/dotfiles/.scripts/fontbrowse.py`.

# Desktop and app settings

## Firefox: keep tabs visible in fullscreen

Either set it by hand: open `about:config`, search for
`browser.fullscreen.autohide`, and set it to `false`.

Or use the tracked profile: run `firefox -P`, set the profile directory to
`~/.ff_custom`, and stow. The `.gitignore` tracks only `.ff_custom/user.js`
from that directory.

## Automatic timezone on boot

Create a systemd service that sets the timezone from your IP address:

```bash
sudoedit /etc/systemd/system/update-timezone.service
```

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

Then enable it:

```bash
sudo systemctl daemon-reload
sudo systemctl enable update-timezone.service
```

## Night light (redshift / gammastep / wlsunset)

- **X11:** redshift
- **Wayland:** gammastep (also works on X11) or wlsunset
- **KDE Plasma:** use the built-in Night Light instead (System Settings >
  Display & Monitor), on either X11 or Wayland

redshift and gammastep can get your location from geoclue. Add a section for
each one you use to `/etc/geoclue/geoclue.conf`:

```
[redshift]
allowed=true
system=true

[gammastep]
allowed=true
system=true
```

wlsunset doesn't use geoclue; pass coordinates instead, e.g.
`wlsunset -l 40.7 -L -74.0`.

# Machine-specific fixes

## Framework: microphone

Edit `/usr/share/alsa-card-profile/mixer/paths/analog-input-internal-mic.conf`.
Under both `[Element Internal Mic Boost]` and `[Element Int Mic Boost]`,
change `volume = merge` to:

```
volume = zero
```

`zero` is a keyword meaning "always 0 dB", i.e. no boost. Don't write `0`: a
number is a raw hardware volume step, which isn't guaranteed to be 0 dB.

The file belongs to the `alsa-card-profiles` package (pulled in by PipeWire),
so an upgrade can overwrite it. Re-check it after updates.

## MacBook Pro: webcam

```bash
paru -S facetimehd-firmware facetimehd-dkms
```

If that doesn't work, follow the
[upstream instructions](https://github.com/patjak/facetimehd/wiki).
