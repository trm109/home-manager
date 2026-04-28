{
  pkgs,
  config,
  lib,
  formfactor,
  ...
}:
let
  cfg = config.modules.graphical.gaming;
in
{
  options.modules.graphical.gaming = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = (formfactor == "desktop") || (formfactor == "laptop"); # Enable by default on desktop and laptop form factors
      description = "Enable gaming applications and settings.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      #steam-run # script for running Steam games
      nwjs
      wl-crosshair
      protonup-qt # GUI for managing Proton versions
      # vintagestory # Vintage Story game
      teamspeak6-client
      steamtinkerlaunch
      xdotool
      xorg.xprop
      unixtools.xxd
      xorg.xwininfo
      yad
      flatpak
      (vintagestory.overrideAttrs (oldAttrs: {
        version = "1.22.0";
        src = pkgs.fetchurl {
          url = oldAttrs.src.url;
          hash = "sha256-c90Mb5hyL8StLFrKokAgER/u6l3jhhluP5ErgVs4geI=";
        };
        nativeBuildInputs = [
          makeWrapper
          copyDesktopItems
        ];
        installPhase = ''
          runHook preInstall

          mkdir -p $out/share/vintagestory $out/bin $out/share/icons/hicolor/512x512/apps $out/share/fonts/truetype
          cp -r * $out/share/vintagestory
          install -Dm444 $out/share/vintagestory/assets/gameicon.png $out/share/icons/hicolor/512x512/apps/vintagestory.png
          cp $out/share/vintagestory/assets/game/fonts/*.ttf $out/share/fonts/truetype

          rm -rvf $out/share/vintagestory/{install,run,server}.sh

          runHook postInstall
        '';
        preFixup =
          builtins.replaceStrings [ "${pkgs.dotnet-runtime_8}" ] [ "${pkgs.dotnet-runtime_10}" ]
            oldAttrs.preFixup;
        # preFixup = ''
        #    makeWrapperArgs+=(--prefix LD_LIBRARY_PATH : "$runtimeLibraryPath")
        #
        #    makeWrapper ${lib.meta.getExe pkgs.dotnet-runtime_10} $out/bin/vintagestory \
        #     "''${makeWrapperArgs[@]}" \
        #      --add-flags $out/share/vintagestory/Vintagestory.dll
        #
        #   makeWrapper ${lib.getExe pkgs.dotnet-runtime_10} $out/bin/vintagestory-server \
        #     "''${makeWrapperArgs[@]}" \
        #     --add-flags $out/share/vintagestory/VintagestoryServer.dll
        #
        #    find "$out/share/vintagestory/assets/" -not -path "*/fonts/*" -regex ".*/.*[A-Z].*" | while read -r file; do
        #      local filename="$(basename -- "$file")"
        #      ln -sf "$filename" "''${file%/*}"/"''${filename,,}"
        #    done
        # '';
      }))
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
