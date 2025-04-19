=========
set-me-up
=========

Running getStarted.sh does an initial setup of the system to my liking. This is meant to be used on Fedora 36 or newer.

Initialize
==========

* ``git clone --recurse-submodules https://github.com/rbjorklin/set-me-up``
* ``cd set-me-up``
* ``sudo ./getStarted.sh <username>``

Update submodules
=================

* ``git submodule update --init --recursive``

Manual stow
===========

.. code-block:: bash

		stow \
				--dir stow \
				--target ~/ \
				--verbose \
				--dotfiles \
				--simulate \
				dotfiles


NixOS
=====

.. code-block:: nix
   :caption: Deploy config to node

    nixos-rebuild switch --flake .#virtualbox

Steam
=====

.. code-block:: console
   :caption: Custom launch command to explicitly set the resolution with a working Steam overly
    env -u LD_PRELOAD gamemoderun gamescope --output-width 3440 --output-height 1440 --nested-width 3440 --nested-height 1440 --hdr-enabled --fullscreen --adaptive-sync --steam --mangoapp --expose-wayland --backend wayland -- env LD_PRELOAD="${LD_PRELOAD}" %command% &> /tmp/steam-error.log

    # For optimal functionality make sure to also set:
    sudo setcap CAP_SYS_NICE=eip /usr/bin/gamescope
    # Where e=Effective, i=Inheritable, p=Permitted

Acknowledgements
================

The neovim config is heavily influenced by `this blog post`_

.. _this blog post: https://nyinyithan.com/nvim-setup-ocaml/
