curl-installed:
  pkg.latest:
    - name: curl

rpmfusion-pkgrepo:
  cmd.script:
    - source: salt://rpmfusion.sh
    - unless: rpm -q rpmfusion-free-release rpmfusion-nonfree-release

dnf-plugins-core:
  cmd.run:
    - name: dnf -y install dnf-plugins-core
    - unless: rpm -q dnf-plugins-core

neovim-pkgrepo:
  cmd.run:
    - name: dnf -y copr enable dperson/neovim
    - unless: dnf copr search neovim | grep -m 1 -o dperson/neovim

fedora-spotify:
  pkgrepo.managed:
    - humanname: negativo17 - Spotify
    - baseurl: http://negativo17.org/repos/spotify/fedora-$releasever/$basearch/
    - gpgkey: http://negativo17.org/repos/RPM-GPG-KEY-slaanesh
    - gpgcheck: 1

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

nvim-init-vim:
  file.symlink:
    - name: /home/{{ pillar['user'] }}/.config/nvim/init.vim
    - target: /srv/files/conf/init.vim
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

nvim-vundle:
  git.latest:
    - name:  https://github.com/gmarik/vundle.git
    - target: /home/{{ pillar['user'] }}/.config/nvim/bundle/Vundle.vim

nvim-vundle-plugins:
  cmd.run:
    - name: sudo -u {{ pillar['user'] }} nvim +PluginInstall +qall > /dev/null

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
