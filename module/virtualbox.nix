{ config, pkgs, lib, ... }:

{
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1"; #Virtualbox Only
    WLR_RENDERER_ALLOW_SOFTWARE = "1"; #Virtualbox Only
    LIBGL_ALWAYS_SOFTWARE = "1"; #Virtualbox Only
  };
}
