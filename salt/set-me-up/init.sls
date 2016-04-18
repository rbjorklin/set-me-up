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

spotify-repo:
  cmd.run:
    - name: dnf config-manager --add-repo=http://negativo17.org/repos/fedora-spotify.repo
    - unless: dnf repolist | grep -m 1 spotify

c-dev-pkg-group:
  cmd.run:
    - name: dnf groupinstall -y "C Development Tools and Libraries"
    - unless: dnf grouplist | grep -Pzo "Installed groups:(.*\n)*Available groups:" | grep "C Development Tools and Libraries"

useful-applications-installed:
  pkg.latest:
    - pkgs:
      - git
      - tmux
      - mosh
      - firefox
      - vlc
      - irssi
      - task
      - levien-inconsolata-fonts
      - zsh
      - ctags
      - neovim
      - spotify-client
      - patch
      - xorg-x11-proto-devel
      - fontconfig-devel
      - libXft-devel
      - libXext-devel

st-terminal:
  cmd.script:
    - source: salt://scripts/build-st.sh
    - unless: test -f /usr/local/bin/st

vconsole-colemak:
  file.managed:
    - name: /etc/vconsole.conf
    - source: salt://conf/vconsole.conf

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

{{ pillar['user'] }}:
  user.present:
    - shell: /usr/bin/zsh
    - remove_groups: False

someone-who-cares-hosts:
  cmd.run:
    - name: curl -s -o /etc/hosts http://someonewhocares.org/hosts/zero/hosts
    - unless: test "$(curl -s http://someonewhocares.org/hosts/zero/hosts | sha512sum)" = "$(cat /etc/hosts | sha512sum)"

nvim-init-vim:
  file.symlink:
    - name: /home/{{ pillar['user'] }}/.config/nvim/init.vim
    - target: /srv/files/conf/init.vim
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

nvim-vim-plug:
  cmd.run:
    - name: curl -sfLo /home/{{ pillar['user'] }}/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    - unless: test -f /home/{{ pillar['user'] }}/.config/nvim/autoload/plug.vim
    - user: {{ pillar['user'] }}

nvim-vundle-plugins:
  cmd.script:
    - source: salt://scripts/nvim-plugins.sh
    - unless: test -d /home/{{ pillar['user'] }}/.config/nvim/plugged
    - user: {{ pillar['user'] }}
    - require:
      - cmd: nvim-vim-plug

solarized-xresources:
  file.symlink:
    - name: /home/{{ pillar['user'] }}/.Xresources
    - target: /srv/files/conf/Xresources
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

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

fix-ownership:
  file.directory:
    - name: /home/{{ pillar['user'] }}
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - recurse:
      - user
      - group
