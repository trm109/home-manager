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
      # (vintagestory.overrideAttrs (prev: {
      #   version = "1.22.0-rc.5";
      #   src = pkgs.fetchurl {
      #     url = "https://cdn.vintagestory.at/gamefiles/unstable/vs_client_linux-x64_1.22.0-rc.5.tar.gz";
      #     hash = "sha256-MvVH9hgM/mcFJ5l89rrnuIP9QfCB/ApOdaj3ja7IHn8=";
      #     # hash = lib.fakeHash;
      #   };
      #   installPhase = ''
      #     runHook preInstall
      #
      #     mkdir -p $out/share/vintagestory $out/bin $out/share/pixmaps $out/share/fonts/truetype
      #     cp -r * $out/share/vintagestory
      #     cp $out/share/vintagestory/assets/game/fonts/*.ttf $out/share/fonts/truetype
      #
      #     runHook postInstall
      #   '';
      #   preFixup =
      #     let
      #       runtimeLibs' = lib.strings.makeLibraryPath prev.runtimeLibs;
      #       dotnet-runtime_10 = pkgs.dotnetCorePackages.runtime_10_0-bin;
      #     in
      #     ''
      #       makeWrapper ${lib.meta.getExe dotnet-runtime_10} $out/bin/vintagestory \
      #         --prefix LD_LIBRARY_PATH : "${runtimeLibs'}" \
      #         --set-default mesa_glthread true \
      #         --set-default OPENTK_4_USE_WAYLAND 1 \
      #         --add-flags $out/share/vintagestory/Vintagestory.dll
      #
      #       makeWrapper ${lib.meta.getExe dotnet-runtime_10} $out/bin/vintagestory-server \
      #         --prefix LD_LIBRARY_PATH : "${runtimeLibs'}" \
      #         --set-default mesa_glthread true \
      #         --add-flags $out/share/vintagestory/VintagestoryServer.dll
      #
      #       find "$out/share/vintagestory/assets/" -not -path "*/fonts/*" -regex ".*/.*[A-Z].*" | while read -r file; do
      #         local filename="$(basename -- "$file")"
      #         ln -sf "$filename" "''${file%/*}"/"''${filename,,}"
      #       done
      #     '';
      # }))
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
