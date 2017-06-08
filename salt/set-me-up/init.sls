# vim: set shiftwidth=2 tabstop=2 softtabstop=2 expandtab autoindent syntax=yaml:
curl-installed:
  pkg.latest:
    - name: curl
    - refresh: True

rpmfusion-pkgrepo:
  cmd.script:
    - source: salt://scripts/rpmfusion.sh
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
{% if pillar['type'].lower() == 'slim' %}
      - vim-enhanced
{% endif %}
{% if pillar['type'] in ['desktop', 'server'] %}
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
      - firefox
      - vlc
      - levien-inconsolata-fonts
      - spotify-client
      # BEGIN st build dependencies
      - patch
      - xorg-x11-proto-devel
      - fontconfig-devel
      - libXft-devel
      - libXext-devel
      # END st

st-terminal:
  cmd.script:
    - source: salt://scripts/build-st.sh
    - unless: test -f /usr/local/bin/st

someone-who-cares-hosts:
  cmd.run:
    - name: curl -s -o /etc/hosts http://someonewhocares.org/hosts/zero/hosts
    - unless: test "$(curl -s http://someonewhocares.org/hosts/zero/hosts | sha512sum)" = "$(cat /etc/hosts | sha512sum)"

solarized-xresources:
  file.symlink:
    - name: /home/{{ pillar['user'] }}/.Xresources
    - target: /srv/files/conf/Xresources
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

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
    - name: curl -sfLo /home/{{ pillar['user'] }}/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    - unless: test -f /home/{{ pillar['user'] }}/.config/nvim/autoload/plug.vim
    - user: {{ pillar['user'] }}

nvim-vim-plug-update-plugins:
  cmd.script:
    - source: salt://scripts/nvim-plugins-update.sh
    - onlyif: test -d /home/{{ pillar['user'] }}/.config/nvim/plugged
    - user: {{ pillar['user'] }}

nvim-vim-plug-install-plugins:
  cmd.script:
    - source: salt://scripts/nvim-plugins-install.sh
    - unless: test -d /home/{{ pillar['user'] }}/.config/nvim/plugged
    - user: {{ pillar['user'] }}

nvim-build-YouCompleteMe:
  cmd.run:
    - name: python3 install.py --gocode-completer
    - cwd: /home/{{ pillar['user'] }}/.config/nvim/plugged/YouCompleteMe
    - unless: test -f /home/{{ pillar['user'] }}/.config/nvim/plugged/YouCompleteMe/third_party/ycmd/ycm_core.so
    - user: {{ pillar['user'] }}

tmux-conf:
  file.symlink:
    - name: /home/{{ pillar['user'] }}/.tmux.conf
    - target: /srv/files/conf/tmux.conf
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

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
    - source: salt://conf/vconsole.conf
{% endif %}
