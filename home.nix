{ pkgs, ... }: {
  programs.home-manager.enable = true;

  home.username = "rbjorklin";
  home.homeDirectory = "/home/rbjorklin";
  home.stateVersion = "23.05";

  services = {
    swayidle = {
        enable = true;
        systemdTarget = "default.target";
# https://github.com/nix-community/home-manager/blob/3feeb7715584fd45ed1389cec8fb15f6930e8dab/modules/services/swayidle.nix#L28-L42
        timeouts = [
          { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -f -c 000000"; }
          { timeout =  360; command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
            resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on"; }
        ];
    };
  };

  home.file = {
    # Tools
    ".gitconfig".source = files/conf/gitconfig;
    ".config/nvim".source = files/conf/nvim;
    ".config/nvim".recursive = true;
    ".tmux.conf".source = files/conf/tmux.conf;
    ".ocamlinit".source = files/conf/ocamlinit;
    ".utoprc".source = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/ocaml-community/utop/fcb7903603cec5e8a2bb4371ea43b1c01f261170/utoprc-dark";
        sha256 = "43e19ef7af7d7d17e3b3f50e0a59ae6ea4e79231db3f759833aaadb181b48bde";
    };

    # Desktop Environment
    ".config/alacritty/alacritty.yml".source = files/conf/alacritty.yml;
    ".config/hypr".source = files/conf/hypr;
    ".config/hypr".recursive = true;
    ".config/waybar".source = files/conf/waybar;
    ".config/waybar".recursive = true;
    ".config/swayidle/config".source = files/conf/swayidle;
    ".config/tofi/config".source = files/conf/tofi;
    ".wallpaper.jpg".source = builtins.fetchurl {
        url = https://w.wallhaven.cc/full/jx/wallhaven-jxyv7q.jpg;
        sha256 = "60014af896e29b6a1a6f0f0541d86c9c34bbc1bf50963cc410362403c3df232f";
    };

    # Shell
    ".zshrc".source = files/conf/zshrc;
    ".zsh/zsh-autosuggestions".source = builtins.fetchGit {
           url = "https://github.com/zsh-users/zsh-autosuggestions";
           rev = "c3d4e576c9c86eac62884bd47c01f6faed043fc5";
        };
    ".zsh/zsh-histdb".source = builtins.fetchGit {
            url = "https://github.com/larkery/zsh-histdb";
            rev = "30797f0c50c31c8d8de32386970c5d480e5ab35d";
        };
    ".zsh/zsh-histdb-skim".source = builtins.fetchGit {
            url = "https://github.com/m42e/zsh-histdb-skim";
            rev = "3af19b6ec38b93c85bb82a80a69bec8b0e050cc5";
        };
    ".config/starship.toml".source = files/conf/starship.toml;
    ".dircolors".source = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/seebi/dircolors-solarized/664dd4e91ff9600a8e8640ef59bc45dd7c86f18f/dircolors.ansi-dark";
        sha256 = "737340690debe040a5bdb8c1f4c0ed3d86e2392cee8646455e8bdd6f237802e7";
    };
  };
}
