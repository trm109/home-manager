{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.graphical.gaming;
in
{
  options.modules.graphical.gaming = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true; # read from /etc/capabilities.nix
      description = "Enable gaming applications and settings.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      #steam-run # script for running Steam games
      nwjs
      wl-crosshair
      protonup-qt # GUI for managing Proton versions
      vintagestory # Vintage Story game
      teamspeak6-client
      steamtinkerlaunch
      xdotool
      xorg.xprop
      unixtools.xxd
      xorg.xwininfo
      yad
      #(vintagestory.overrideAttrs rec {
      #  version = "1.21.4";
      #  src = pkgs.fetchurl {
      #    url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_1.21.4.tar.gz";
      #    hash = lib.fakeHash;
      #  };
      #})
      goverlay # mangohud configuration tool
      (prismlauncher.override {
        jdks = [
          jdk8
          jdk17
          jdk21
        ];
      })
      r2modman
      gale
      # (r2modman.overrideAttrs rec {
      #   version = "3.2.13";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "ebkr";
      #     repo = "r2modmanPlus";
      #     rev = "baaf338e6bdb1ab4020676ed38dd3ca85318171d";
      #     hash = "sha256-dy+xVGh5VNGXI34ecglLFl/h6SXyUdfzyvLCjXYmC/w=";
      #   };
      # })
      keyd # gives access to the userspace keyd tool "keyd-application-mapper", allows for application based remapping in userspace. Can be a security risk.
    ];

    programs = {
      mangohud = {
        enable = true; # Performance overlay for Vulkan and OpenGL applications
      };
    };
  };
}
