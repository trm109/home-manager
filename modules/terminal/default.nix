{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.terminal;
in
{
  imports = [
    ./nixvim.nix
  ];
  options.modules.terminal = {
    enable = lib.mkOption {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    modules.terminal.nixvim.enable = true;
    home.packages = with pkgs; [
      unrar
      unzip
      btop
      tre-command
      gh
      fastfetch
      fzf
      tldr
      devenv
      direnv
      bat
      rclone
      jq
      grc
      nix-prefetch-git
      nix-prefetch-github
      nix-search-cli
      podman-compose
    ];
    programs = {
      tmux = {
        enable = true;
      };
      direnv = {
        enable = true;
      };
      # TODO nix-index?
      fish = {
        enable = true;
        #plugins = with pkgs.fishPlugins; [
        #  done # notify when a long process finished
        #  fzf-fish # fzf integration for fish
        #  forgit
        #  hydro # async git status
        #  tide
        #  colored-man-pages
        #];
        functions = {
          gitree = "git log --all --graph --decorate --oneline";
          gitac = "git add -A && git commit -m $argv";
        };
      };
    };
    services = {
      podman = {
        enable = true;
      };
    };
  };
}
