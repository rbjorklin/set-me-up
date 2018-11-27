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

dnf-plugins-core:
  cmd.run:
    - name: dnf -y install dnf-plugins-core
    - unless: rpm -q dnf-plugins-core

{% if pillar['type'].lower() == 'server' %}
neovim-repo:
  cmd.run:
    - name: curl -o /etc/yum.repos.d/dperson-neovim-epel-7.repo https://copr.fedorainfracloud.org/coprs/dperson/neovim/repo/epel-7/dperson-neovim-epel-7.repo
    - unless: test -f /etc/yum.repos.d/dperson-neovim-epel-7.repo
{% endif %}

base-applications-installed:
  pkg.latest:
    - pkgs:
      - git
      - tmux
      - mosh
      - zip
      - unzip
{% if pillar['type'].lower() == 'slim' %}
      - vim-enhanced
{% endif %}
{% if pillar['type'].lower() in ['desktop', 'server'] %}
      - neovim
      - ctags
      - irssi
      - task
      - zsh
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
{% endif %}

{% if pillar['type'].lower() == 'desktop' %}

{% for application, url in [('vagrant', 'https://www.vagrantup.com/downloads.html'), ('slack', 'https://slack.com/downloads/instructions/fedora')] %}
{% set applicationDownload = salt['cmd.shell']('curl -s ' + url + ' | grep -m 1 -o "https://.*x86_64\.rpm" | head -n 1') %}
{% set applicationVersion = salt['cmd.shell']('echo ' + applicationDownload + ' | egrep -m 1 -o "[0-9]\.[0-9]+\.[0-9]+" | head -n 1') %}

{{ application }}-installed:
  cmd.run:
    - name: curl -s {{ applicationDownload }} -o /tmp/{{ application }}_x86_64.rpm && dnf install -y /tmp/{{ application }}_x86_64.rpm && rm -f /tmp/{{ application }}_x86_64.rpm
    - unless: rpm -q {{ application }}-{{ applicationVersion }}
{% endfor %}

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
        Icon=utilities-terminal
        Type=Application
        X-GNOME-DocPath=gnome-terminal/index.html
        X-GNOME-Bugzilla-Bugzilla=GNOME
        X-GNOME-Bugzilla-Product=gnome-terminal
        X-GNOME-Bugzilla-Component=BugBuddyBugs
        Categories=GNOME;GTK;System;TerminalEmulator;
        StartupNotify=true
        X-GNOME-SingleWindow=false
{% endif %}

someone-who-cares-hosts:
  cmd.run:
    - name: curl -s -o /etc/hosts http://someonewhocares.org/hosts/zero/hosts
    - unless: test "$(curl -s http://someonewhocares.org/hosts/zero/hosts | sha512sum)" = "$(cat /etc/hosts | sha512sum)"

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

oh-my-zsh:
  git.latest:
    - name: https://github.com/robbyrussell/oh-my-zsh.git
    - target: /home/{{ pillar['user'] }}/.oh-my-zsh

oh-my-zsh-zshrc:
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

{% if pillar['type'].lower() in ['desktop', 'server'] %}
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
{% endif %}

lein-installed:
  cmd.run:
    - name: curl -s -L -o /usr/local/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
    - unless: test -f /usr/local/bin/lein

lein-completion-installed:
  cmd.run:
    - name: curl -s -L -o /usr/share/zsh/site-functions/_lein https://raw.githubusercontent.com/technomancy/leiningen/master/zsh_completion.zsh
    - unless: test -f /usr/share/zsh/site-functions/_lein

fix-ownership:
  file.directory:
    - name: /home/{{ pillar['user'] }}
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 700
    - recurse:
      - user
      - group

systemd-resolved:
  service.running:
    - name: systemd-resolved
    - enable: True
  file.symlink:
    - name: /etc/resolv.conf
    - target: /run/systemd/resolve/stub-resolv.conf
    - force: True
