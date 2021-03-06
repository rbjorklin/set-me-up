---
# vim: set shiftwidth=2 tabstop=2 softtabstop=2 expandtab autoindent syntax=yaml:

{% set uid = salt['cmd.run']('id -u ' + pillar['user']) %}
{% set gid = salt['cmd.run']('id -g ' + pillar['user']) %}

curl-installed:
  pkg.latest:
    - name: curl
    - refresh: true

rpmfusion-pkgrepo:
  cmd.run:
    - name: |
        curl -L -s -o RPM-GPG-KEY-rpmfusion-nonfree-fedora-$(rpm -E %fedora) "http://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-nonfree-fedora-$(rpm -E %fedora)"
        curl -L -s -o RPM-GPG-KEY-rpmfusion-free-fedora-$(rpm -E %fedora) "http://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-free-fedora-$(rpm -E %fedora)"
        rpm --import RPM-GPG-KEY-rpmfusion-free-fedora-$(rpm -E %fedora)
        rpm --import RPM-GPG-KEY-rpmfusion-nonfree-fedora-$(rpm -E %fedora)
        rm RPM-GPG-KEY-rpmfusion-*free-fedora-$(rpm -E %fedora)
        dnf install -y http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    - unless: rpm -q rpmfusion-free-release rpmfusion-nonfree-release

vscode-gpg-key:
  cmd.run:
    - name: rpm --import https://packages.microsoft.com/keys/microsoft.asc
    - unless: rpm -q gpg-pubkey-be1229cf-5631588c

vscode-pkgrepo:
  pkgrepo.managed:
    - name: VSCode
    - humanname: Visual Studio Code
    - baseurl: https://packages.microsoft.com/yumrepos/vscode
    - enabled: 1
    - gpgcheck: 1
    - gpgkey: https://packages.microsoft.com/keys/microsoft.asc

dnf-plugins-core:
  cmd.run:
    - name: dnf -y install dnf-plugins-core
    - unless: rpm -q dnf-plugins-core

dnf-copr-fira-code:
  cmd.run:
    - name: dnf -y copr enable evana/fira-code-fonts
    - unless: rpm -q fira-code-fonts

dnf-copr-alacritty:
  cmd.run:
    - name: dnf -y copr enable pschyska/alacritty
    - unless: rpm -q alacritty

spotify-repo:
  cmd.run:
    - name: dnf config-manager --add-repo=http://negativo17.org/repos/fedora-spotify.repo
    - unless: dnf repolist | grep -m 1 spotify

docker-ce-repo:
  cmd.run:
    - name: dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    - unless: test -f /etc/yum.repos.d/docker-ce.repo

base-applications-installed:
  pkg.latest:
    - pkgs:
      - git
      - tmux
      - mosh
      - zip
      - unzip
      - ripgrep
      - neovim
      - python3-neovim
      - ctags
      - irssi
      - task
      - zsh
      - code
      - fira-code-fonts
      - alacritty
      - jq
      - firefox
      - vlc
      - thunderbird
      - levien-inconsolata-fonts
      - mozilla-fira-mono-fonts
      - mozilla-fira-sans-fonts
      - spotify-client
      - java-latest-openjdk-headless
      - gpaste
      - gpaste-ui
      - gnome-shell-extension-gpaste
      - VirtualBox
      - akmod-VirtualBox
      - gnome-tweaks
      - kernel-modules-extra # xpad etc.
      - yamllint
      - dconf-editor
      - nodejs # coc-nvim
      - pv
      - evolution
      - podman
      - docker-ce
      - docker-compose

docker-ce-dropin:
  file.managed:
    - name: /etc/docker/daemon.json
    - makedirs: true
    - contents: |
        {
          "ipv6": false,
          "userns-remap": "{{ uid }}:{{ gid }}"
        }

docker-ce-running:
  service.running:
    - name: docker
    - enable: true

{% for application, url in [('vagrant', 'https://www.vagrantup.com/downloads.html')] %}
{% set applicationDownload = salt['cmd.shell']('curl -s ' + url + ' | grep -m 1 -o "https://.*x86_64\.rpm" | head -n 1') %}
{% set applicationVersion = salt['cmd.shell']('echo ' + applicationDownload + ' | egrep -m 1 -o "[0-9]\.[0-9]+\.[0-9]+" | head -n 1') %}

{{ application }}-installed:
  cmd.run:
    - name: curl -s {{ applicationDownload }} -o /tmp/{{ application }}_x86_64.rpm && dnf install -y /tmp/{{ application }}_x86_64.rpm && rm -f /tmp/{{ application }}_x86_64.rpm
    - unless: rpm -q {{ application }}-{{ applicationVersion }}
{% endfor %}

install-rust:
  cmd.run:
    - name: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    - unless: which rustc cargo
    - runas: {{ pillar['user'] }}

upgrade-rust:
  cmd.run:
    - name: rustup update
    - runas: {{ pillar['user'] }}

setup-starship:
  cmd.run:
    - name: cargo install starship
    - unless: which starship
    - runas: {{ pillar['user'] }}

{% set vaultVersion = salt['cmd.shell']('curl -s https://releases.hashicorp.com/vault/ | grep -v "beta\|ent" | egrep -om 1 "vault_[0-9]+\.[0-9]+\.[0-9]+" | cut -d _ -f 2-') %}
install-vault:
  file.managed:
    - name: /tmp/vault.zip
    - source: https://releases.hashicorp.com/vault/{{ vaultVersion }}/vault_{{ vaultVersion }}_linux_amd64.zip
    - skip_verify: true
    - unless: test -x /usr/local/bin/vault

  archive.extracted:
    - name: /usr/local/bin
    - source: /tmp/vault.zip
    - if_missing: /usr/local/bin/vault
    - enforce_toplevel: false

{% set terraformVersion = salt['cmd.shell']('curl -s https://releases.hashicorp.com/terraform/ | grep -v "beta\|ent" | egrep -om 1 "terraform_[0-9]+\.[0-9]+\.[0-9]+" | cut -d _ -f 2-') %}
install-terraform:
  file.managed:
    - name: /tmp/terraform.zip
    - source: https://releases.hashicorp.com/terraform/{{ terraformVersion }}/terraform_{{ terraformVersion }}_linux_amd64.zip
    - skip_verify: true
    - unless: test -x /usr/local/bin/terraform

  archive.extracted:
    - name: /usr/local/bin
    - source: /tmp/terraform.zip
    - if_missing: /usr/local/bin/terraform
    - enforce_toplevel: false

zsh-autosuggesions:
  git.cloned:
    - name: https://github.com/zsh-users/zsh-autosuggestions
    - target: /home/{{ pillar['user'] }}/.zsh/zsh-autosuggestions
    - runas: {{ pillar['user'] }}

gnome-app-switcher-only-current-workspace:
  cmd.run:
    - name: gsettings set org.gnome.shell.app-switcher current-workspace-only true
    - unless: gsettings get org.gnome.shell.app-switcher current-workspace-only | grep true
    - runas: {{ pillar['user'] }}

gnome-calendar-show-week:
  cmd.run:
    - name: gsettings set org.gnome.desktop.calendar show-weekdate true
    - unless: gsettings get org.gnome.desktop.calendar show-weekdate | grep true
    - runas: {{ pillar['user'] }}

gnome-experimental-fractional-scaling:
  cmd.run:
    - name: gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
    - unless: gsettings get org.gnome.mutter experimental-features | grep scale-monitor-framebuffer
    - runas: {{ pillar['user'] }}

alacritty-with-tmux-for-startup:
  file.managed:
    - name: /home/{{ pillar['user'] }}/.local/share/applications/alacritty-tmux.desktop
    - makedirs: true
    - contents: |
        [Desktop Entry]
        Type=Application
        TryExec=alacritty
        Exec=alacritty -e tmux
        Icon=Alacritty
        Terminal=false
        Categories=System;TerminalEmulator;

        Name=Alacritty Tmux
        GenericName=Terminal
        Comment=A cross-platform, GPU enhanced terminal emulator
        StartupWMClass=Alacritty
        Actions=New;

        [Desktop Action New]
        Name=New Terminal
        Exec=alacritty

solarized-dircolors:
  file.managed:
    - name: /home/{{ pillar['user'] }}/.dircolors
    - source: https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.ansi-dark
    - skip_verify: true

someone-who-cares-hosts:
  cmd.run:
    - name: curl -sLo /etc/hosts http://someonewhocares.org/hosts/zero/hosts
    - unless: test "$(curl -sL http://someonewhocares.org/hosts/zero/hosts | sha512sum)" = "$(cat /etc/hosts | sha512sum)"

{% set latestInterFontZip = salt['cmd.shell']("curl -s https://api.github.com/repos/rsms/inter/releases/latest | jq -r '.assets[] | select(.content_type == \"application/zip\").browser_download_url'") %}
inter-font-download:
  file.managed:
    - name: /tmp/inter-fonts.zip
    - source: {{ latestInterFontZip }}
    - skip_verify: true
    - unless: test -f /home/{{ pillar['user'] }}/.local/share/fonts/Inter.otf

local-fonts-dir:
  file.directory:
    - name: /home/{{ pillar['user'] }}/.local/share/fonts
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

inter-font-unpack:
  cmd.run:
    - name: unzip -ufoj /tmp/inter-fonts.zip */*.otf
    - cwd: /home/{{ pillar['user'] }}/.local/share/fonts
    - unless: test -f /home/{{ pillar['user'] }}/.local/share/fonts/Inter.otf

inter-font-symlink:
  file.symlink:
    - name: /home/{{ pillar['user'] }}/.fonts
    - target: /home/{{ pillar['user'] }}/.local/share/fonts
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

inter-font-dir:
  file.directory:
    - name: /home/{{ pillar['user'] }}/.fonts
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - recurse:
      - user
      - group

inter-font-update-cache:
  cmd.run:
    - name: fc-cache -f -v
    - onchanges:
      - file: inter-font-download
      - file: local-fonts-dir
      - file: inter-font-symlink
      - file: inter-font-dir
      - cmd: inter-font-unpack

gitconfig:
  file.symlink:
    - name: /home/{{ pillar['user'] }}/.gitconfig
    - target: /srv/files/conf/gitconfig
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

change-user-shell:
  user.present:
    - name: {{ pillar['user'] }}
    - shell: /usr/bin/zsh
    - remove_groups: false
    - groups:
      - docker

zshrc-symlink:
  file.symlink:
    - name: /home/{{ pillar['user'] }}/.zshrc
    - target: /srv/files/conf/zshrc
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

nvim-init-vim:
  file.symlink:
    - name: /home/{{ pillar['user'] }}/.config/nvim/init.vim
    - target: /srv/files/conf/init.vim
    - makedirs: true
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

nvim-coc-settings:
  file.symlink:
    - name: /home/{{ pillar['user'] }}/.config/nvim/coc-settings.json
    - target: /srv/files/conf/coc-settings.json
    - makedirs: true
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

nvim-vim-plug:
  cmd.run:
    - name: curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    - unless: test -f ~/.local/share/nvim/site/autoload/plug.vim
    - runas: {{ pillar['user'] }}

nvim-vim-plug-install-plugins:
  cmd.run:
    - name: nvim --headless -c PlugInstall -c quitall
    - unless: test -d ~/.local/share/nvim/plugged
    - runas: {{ pillar['user'] }}

tmux-conf:
  file.symlink:
    - name: /home/{{ pillar['user'] }}/.tmux.conf
    - target: /srv/files/conf/tmux.conf
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

task-conf:
  file.symlink:
    - name: /home/{{ pillar['user'] }}/.taskrc
    - target: /srv/files/conf/taskrc
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

alacritty-symlink:
  file.symlink:
    - name: /home/{{ pillar['user'] }}/.config/alacritty/alacritty.yml
    - target: /srv/files/conf/alacritty.yml
    - makedirs: true
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

starship-symlink:
  file.symlink:
    - name: /home/{{ pillar['user'] }}/.config/starship.toml
    - target: /srv/files/conf/starship.toml
    - makedirs: true
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

vconsole-colemak:
  file.managed:
    - name: /etc/vconsole.conf
    - contents: |
        KEYMAP="us-colemak"
        FONT="eurlatgr"

prep-for-fix-ownership:
  cmd.run:
    - name: find . -xtype l -print -exec rm -f {} \;
    - cwd: /home/{{ pillar['user'] }}/
    - runas: {{ pillar['user'] }}

# This breaks if the folder contains broken symlinks: https://github.com/saltstack/salt/issues/49204
# remove symlinks with: find . -xtype l -exec rm -f {} \;
fix-ownership:
  file.directory:
    - name: /home/{{ pillar['user'] }}
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - dir_mode: 700
    - recurse:
      - user
      - group

# need to figure out how to fix the problems resolved cause with VPNs
#systemd-resolved:
#  service.running:
#    - name: systemd-resolved
#    - enable: true
#  file.symlink:
#    - name: /etc/resolv.conf
#    - target: /run/systemd/resolve/stub-resolv.conf
#    - force: true

systemd-packagekit:
  service.dead:
    - name: packagekit
    - enable: false
  file.absent:
    - name: /var/cache/PackageKit
  pkg.purged:
    - pkgs:
      - PackageKit
      - PackageKit-gstreamer-plugin
      - PackageKit-command-not-found
      - PackageKit-gtk3-module
      - PackageKit-glib

sysctl-tune-dirty-bytes:
  file.managed:
    - name: /etc/sysctl.d/01-dirty-bytes.conf
    - source: salt://conf/01-dirty-bytes.conf

# Dleyna leaks memory so we don't want it
remove-dleyna:
  pkg.purged:
    - pkgs:
      - dleyna-core
      - dleyna-server
      - dleyna-renderer
      - dleyna-connector-dbus
