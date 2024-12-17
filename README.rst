=========
set-me-up
=========

Running getStarted.sh does an initial setup of the system to my liking. This is meant to be used on Fedora 36 or newer.

You want to use this?
=====================

* ``git clone https://github.com/rbjorklin/set-me-up``
* ``cd set-me-up``
* ``sudo ./getStarted.sh <username>``

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

Acknowledgements
================

The neovim config is heavily influenced by `this blog post`_

.. _this blog post: https://nyinyithan.com/nvim-setup-ocaml/
