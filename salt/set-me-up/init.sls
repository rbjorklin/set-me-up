# vim: set shiftwidth=2 tabstop=2 softtabstop=2 expandtab autoindent syntax=yaml:
curl-installed:
  pkg.latest:
    - name: curl
    - refresh: True

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
      - ctags
      - irssi
      - task
      - zsh
      - code
      - fira-code-fonts
      - alacritty
      # BEGIN YouCompleteMe build dependencies
      - automake
      - gcc
      - gcc-c++
      - kernel-devel
      - cmake
      - python3-devel
      - python3-msgpack
      - python3-greenlet
      - python3-neovim
      - golang
      - gotags
      # END YouCompleteMe

{% for application, url in [('vagrant', 'https://www.vagrantup.com/downloads.html'), ('slack', 'https://slack.com/downloads/instructions/fedora')] %}
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

setup-starship:
  cmd.run:
    - name: cargo install starship
    - unless: which starship
    - runas: {{ pillar['user'] }}

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

gnome-font-hinting-slight:
  cmd.run:
    - name: gsettings set org.gnome.settings-daemon.plugins.xsettings hinting slight
    - unless: gsettings get org.gnome.settings-daemon.plugins.xsettings hinting | grep slight
    - runas: {{ pillar['user'] }}

gnome-font-hinting-subpixel:
  cmd.run:
    - name: gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing rgba
    - unless: gsettings get org.gnome.settings-daemon.plugins.xsettings antialiasing | grep rgba
    - runas: {{ pillar['user'] }}

gnome-font-hinting-lcdfilter:
  file.symlink:
    - name: /etc/fonts/conf.d/11-lcdfilter-default.conf
    - target: /usr/share/fontconfig/conf.avail/11-lcdfilter-default.conf
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

gnome-set-document-font-fira-sans:
  cmd.run:
    - name: gsettings set org.gnome.desktop.interface document-font-name "Fira Sans 11"
    - unless: gsettings get org.gnome.desktop.interface document-font-name | grep "Fira Sans 11"
    - runas: {{ pillar['user'] }}

gnome-set-monospace-font-fira-mono:
  cmd.run:
    - name: gsettings set org.gnome.desktop.interface monospace-font-name "Fira Mono 11"
    - unless: gsettings get org.gnome.desktop.interface monospace-font-name | grep "Fira Mono 11"
    - runas: {{ pillar['user'] }}

spotify-repo:
  cmd.run:
    - name: dnf config-manager --add-repo=http://negativo17.org/repos/fedora-spotify.repo
    - unless: dnf repolist | grep -m 1 spotify

docker-ce-repo:
  cmd.run:
    - name: dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    - unless: test -f /etc/yum.repos.d/docker-ce.repo

desktop-applications-installed:
  pkg.latest:
    - refresh: True
    - pkgs:
      - jq
      - firefox
      - vlc
      - thunderbird
      - levien-inconsolata-fonts
      - mozilla-fira-mono-fonts
      - mozilla-fira-sans-fonts
      - spotify-client
      - java-1.8.0-openjdk-devel
      - gpaste
      - gpaste-ui
      - gnome-shell-extension-gpaste
      - VirtualBox
      - akmod-VirtualBox
      - gnome-tweaks
      - freetype-freeworld # Fedora subpixel font rendering
      - docker-ce
      - kernel-modules-extra # xpad etc.
      - chrome-gnome-shell # install gnome-shell extensions such as shelltile through Firefox

docker-ce-dropin:
  file.managed:
    - name: /etc/systemd/system/docker.service.d/localhost-tcp.conf
    - makedirs: True
    - contents: |
        [Service]
        ExecStart=
        ExecStart=/usr/bin/dockerd -H unix:// -H tcp://127.0.0.1:2375

docker-ce-running:
  service.running:
    - name: docker
    - enable: True

gnome-terminal-with-tmux-for-startup:
  file.managed:
    - name: /home/{{ pillar['user'] }}/.local/share/applications/org.gnome.Terminal.tmux.desktop
    - makedirs: True
    - contents: |
        [Desktop Entry]
        Name=Terminal with tmux
        Comment=Use the command line
        Keywords=shell;prompt;command;commandline;cmd;
        TryExec=gnome-terminal
        Exec=gnome-terminal -- tmux
        Icon=org.gnome.Terminal
        Type=Application
        X-GNOME-DocPath=gnome-terminal/index.html
        X-GNOME-Bugzilla-Bugzilla=GNOME
        X-GNOME-Bugzilla-Product=gnome-terminal
        X-GNOME-Bugzilla-Component=BugBuddyBugs
        Categories=GNOME;GTK;System;TerminalEmulator;
        StartupNotify=true
        X-GNOME-SingleWindow=false

alacritty-with-tmux-for-startup:
  file.managed:
    - name: /home/{{ pillar['user'] }}/.local/share/applications/alacritty-tmux.desktop
    - makedirs: True
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
    - skip_verify: True

someone-who-cares-hosts:
  cmd.run:
    - name: curl -sLo /etc/hosts http://someonewhocares.org/hosts/zero/hosts
    - unless: test "$(curl -sL http://someonewhocares.org/hosts/zero/hosts | sha512sum)" = "$(cat /etc/hosts | sha512sum)"

{% set latestInterFontZip = salt['cmd.shell']('curl -s https://api.github.com/repos/rsms/inter/releases/latest | jq -r ".assets[].browser_download_url"') %}
inter-font-download:
  file.managed:
    - name: /tmp/inter-fonts.zip
    - source: {{ latestInterFontZip }}
    - skip_verify: True

inter-font-unpack:
  cmd.run:
    - name: unzip -uj /tmp/inter-fonts.zip */*.otf
    - cwd: /home/{{ pillar['user'] }}/.local/share/fonts

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

{% if pillar['user'].lower() != 'n/a' %}
gitconfig:
  file.symlink:
    - name: /home/{{ pillar['user'] }}/.gitconfig
    - target: /srv/files/conf/gitconfig
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

create-user-{{ pillar['user'] }}:
  user.present:
    - name: {{ pillar['user'] }}
    - shell: /usr/bin/zsh
    - remove_groups: False

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
    - makedirs: True
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

{% include 'set-me-up/upgrade-intellij.sls' %}
    - unless: test -d ~/.local/share/intellij

tmux-conf:
  file.symlink:
    - name: /home/{{ pillar['user'] }}/.tmux.conf
    - target: /srv/files/conf/tmux.conf
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

sdkman-installed:
  cmd.run:
    - name: curl -s "https://get.sdkman.io" | zsh
    - runas: {{ pillar['user'] }}
    - unless: test -d ~/.sdkman

task-conf:
  file.symlink:
    - name: /home/{{ pillar['user'] }}/.taskrc
    - target: /srv/files/conf/taskrc
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

vconsole-colemak:
  file.managed:
    - name: /etc/vconsole.conf
    - contents: |
        KEYMAP="us-colemak"
        FONT="eurlatgr"
{% endif %}

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
#    - enable: True
#  file.symlink:
#    - name: /etc/resolv.conf
#    - target: /run/systemd/resolve/stub-resolv.conf
#    - force: True

systemd-packagekit:
  service.dead:
    - name: packagekit
    - enable: False
  file.absent:
    - name: /var/cache/PackageKit
