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

neovim-repo:
  cmd.run:
    - name: dnf -y copr enable dperson/neovim
    - unless: dnf repolist | grep -m 1 dperson-neovim

{% if pillar['type'].lower() == 'desktop' %}
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

spotify-repo:
  cmd.run:
    - name: dnf config-manager --add-repo=http://negativo17.org/repos/fedora-spotify.repo
    - unless: dnf repolist | grep -m 1 spotify
{% endif %}

useful-applications-installed:
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
      - VirtualBox
      - akmod-VirtualBox

{% set vagrantDownload = salt['cmd.run']('curl -s https://www.vagrantup.com/downloads.html | grep -o "https://.*x86_64\.rpm"') %}

vagrant-installed:
  cmd.run:
    - name: curl -s {{ vagrantDownload }} -o /tmp/vagrant_x86_64.rpm && dnf install -y /tmp/vagrant_x86_64.rpm && rm -f /tmp/vagrant_x86_64.rpm
    - unless: rpm -q vagrant

someone-who-cares-hosts:
  cmd.run:
    - name: curl -s -o /etc/hosts http://someonewhocares.org/hosts/zero/hosts
    - unless: test "$(curl -s http://someonewhocares.org/hosts/zero/hosts | sha512sum)" = "$(cat /etc/hosts | sha512sum)"

gitconfig:
  file.symlink:
    - name: /home/{{ pillar['user'] }}/.gitconfig
    - target: /srv/files/conf/gitconfig
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
{% endif %}

{% if pillar['user'].lower() != 'n/a' %}
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
{% endif %}

fix-ownership:
  file.directory:
    - name: /home/{{ pillar['user'] }}
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 700
    - recurse:
      - user
      - group
{% endif %}

{% if pillar['type'] in ['desktop', 'server'] %}
vconsole-colemak:
  file.managed:
    - name: /etc/vconsole.conf
    - contents: |
        KEYMAP="us-colemak"
        FONT="eurlatgr"
{% endif %}
