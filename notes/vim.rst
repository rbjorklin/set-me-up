Vim
===

Sessions
--------

::

  # Open vim and create new windows with commands
  :split +set\ nonu term://dune build @install --watch

  # Save session
  :mksession my-session.vim

  # Re-open session
  vim -S my-session.vim
