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
      protonup-qt # GUI for managing Proton versions
      (vintagestory.overrideAttrs rec {
        version = "1.20.10";
        src = pkgs.fetchurl {
          url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${version}.tar.gz";
          hash = "sha256-AMXnq6fy1AtwmdhuuEawlWIyS4kq10HkgxnqgArqWR4=";
        };
      })
      goverlay # mangohud configuration tool
      (prismlauncher.override {
        jdks = [
          jdk8
          jdk17
          jdk21
        ];
      })
      (r2modman.overrideAttrs (
        let
          src = pkgs.fetchFromGitHub {
            owner = "ebkr";
            repo = "r2modmanPlus";
            rev = "59c1fe5287593eb58b4ce6d5d8f2ca59ca64bfd4";
            hash = "sha256-1b24tclqXGx85BGFYL9cbthLScVWau2OmRh9YElfCLs=";
          };
        in
        {
          inherit src;
          offlineCache = pkgs.fetchYarnDeps {
            yarnLock = "${src}/yarn.lock";
            hash = "sha256-3SMvUx+TwUmOur/50HDLWt0EayY5tst4YANWIlXdiPQ=";
          };
        }
      ))
    ];

    programs = {
      mangohud = {
        enable = true; # Performance overlay for Vulkan and OpenGL applications
      };
    };
  };
}
