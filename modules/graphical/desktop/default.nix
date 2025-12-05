{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.graphical.desktop;
in
{
  imports = [
    ./compositor.nix
  ];
  options.modules.graphical.desktop = {
    desktopEnvironment = lib.mkOption {
      type = lib.types.enum [
        "hyprland"
      ];
      default = "hyprland";
      description = "Choose the desktop environment to use.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.desktopEnvironment == "hyprland") {
      modules.graphical.desktop.compositor.type = "wayland";
      home = {
        packages = with pkgs; [
          hyprshot # Screenshot tool for Hyprland
          brightnessctl # Screen brightness control
          #upower # TODO laptop only
        ];
        sessionVariables = {
          HYPRSHOT_DIR = "/home/${config.home.username}/Pictures/Screenshots"; # Set default screenshot directory
          HYPRCURSOR_THEME = "rose-pine-hyprcursor"; # Set cursor theme
          DXVK_HDR = 1;
          ENABLE_HDR_WSI = 1;
          #WAYLAND_DISPLAY = "wayland-0"; # Set Wayland display
        };
      };
      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true; # Enable XWayland for compatibility with X11 applications
        plugins = [ ];
        settings = {
          experimental = {
            xx_color_management_v4 = true; # Enable experimental color management
          };
          exec-once = [
            #"${pkgs.hyprpaper}/bin/hyprpaper" # Wallpaper manager for Hyprland
            #"${pkgs.hyprpanel}/bin/hyprpanel" # Panel for Hyprland
            "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            "${pkgs.dbus}/bin/dbus-update-activation-environment --all"
            "${pkgs.systemd}/bin/systemctl --user start hyprpolkitagent"
          ];
          monitor = [
            ", highres, auto, 1"
            "desc:AOC Q27G3XMN 1APQAJA001629, 2560x1440@180, auto-right, 1, bitdepth, 10, cm, hdr, sdrbrightness, 1.4, sdrsaturation, 1"
            #"desc:AOC Q27G3XMN 1APQAJA001629, 2560x1440@180, 0x0, 1, bitdepth, 10"
            "desc:AOC U34G2G4R3 0x000045A1, 3440x1440@144, 0x0, 1, bitdepth, 10, cm, hdr, sdrbrightness, 1.4, sdrsaturation, 1"
            "desc:Hisense Electric Co. Ltd. HISENSE 0x00000001, 1920x1080@60, auto-down, 1"
          ];
          workspace = [
            "2, monitor:desc:AOC Q27G3XMN, default:true"
            "1, monitor:desc:AOC U34G2G4R3, default:true"
            "name:bedroom, monitor:desc:Hisense Electric Co. Ltd. HISENSE 0x00000001, default:true, gapsout:35"
          ];
          windowrule = [
            "noinitialfocus, class:steam"
            #"float, class:(steam_app_.*)"
            #"float, title:(Steam Big Picture Mode)"
            #  "workspace 1, class:(steam_app_.*)"
            #  "workspace 1, title:(Steam Big Picture Mode)"
            #  "fullscreen, title:(Steam Big Picture Mode)"
            #  "stayfocused, title:(Steam Big Picture Mode)"
          ];
          general = {
            gaps_in = 4;
            gaps_out = 4;
            border_size = 2;
          };
          debug = {
            full_cm_proto = true;
          };
          decoration = {
            rounding = 10;
          };
          input = {
            kb_layout = "us"; # Set keyboard layout
            numlock_by_default = true; # Enable numlock by default
            accel_profile = "flat"; # Set mouse acceleration profile
            repeat_delay = 250; # Key repeat delay in milliseconds
          };
          misc = {
            disable_hyprland_logo = true; # Disable Hyprland logo
            force_default_wallpaper = true; # Force default wallpaper
            vfr = true;
            vrr = 1;
            focus_on_activate = true; # Focus on window when activated
            new_window_takes_over_fullscreen = 2;
          };
          render = {
            direct_scanout = 2;
          };
          "$mainMod" = "SUPER";
          bindle = [
            ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify-send 'Volume: $(wpctl get-volume @DEFAULT_AUDIO_SINK@)' -h string:x-canonical-private-synchronous:volume"
            ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && notify-send 'Volume: $(wpctl get-volume @DEFAULT_AUDIO_SINK@)' -h string:x-canonical-private-synchronous:volume"
          ];
          bindl = [
            ", XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle && notify-send 'Toggled Mic: $(pactl get-source-mute @DEFAULT_SOURCE@)' -h string:x-canonical-private-synchronous:microphone_muted"
            ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle && notify-send 'Volume Muted' -h string:x-canonical-private-synchronous:volume_muted"
            ", KP_Subtract, exec, hyprctl keyword cursor:zoom_factor 1"
            ", KP_Add, exec, hyprctl keyword cursor:zoom_factor 2"
          ];
          bindr = [
            "SUPER, SUPER_L, exec, ${pkgs.busybox}/bin/pkill ${pkgs.fuzzel}/bin/fuzzel || ${pkgs.fuzzel}/bin/fuzzel"
          ];
          bindm = [
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];
          bind = [
            "$mainMod, S, exec, ${pkgs.hyprshot}/bin/hyprshot -m output" # sc entire screen
            "$mainMod SHIFT, S, exec, ${pkgs.hyprshot}/bin/hyprshot -m region" # sc region
            "$mainMod, K, exec, ${pkgs.ghostty}/bin/ghostty"
            "$mainMod, L, exec, ${pkgs.hyprlock}/bin/hyprlock"
            "$mainMod, Q, killactive"
            "$mainMod, V, togglefloating"
            "$mainMod, J, togglesplit"
            "$mainMod, left, movefocus, l"
            "$mainMod, right, movefocus, r"
            "$mainMod, up, movefocus, u"
            "$mainMod, down, movefocus, d"
            "$mainMod, F, fullscreen"
            "Alt SHIFT, F, fullscreenstate, 0 3"
            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"
            "$mainMod, C, workspace, name:bedroom"
            "$mainMod SHIFT, 1, movetoworkspace, 1"
            "$mainMod SHIFT, 2, movetoworkspace, 2"
            "$mainMod SHIFT, 3, movetoworkspace, 3"
            "$mainMod SHIFT, 4, movetoworkspace, 4"
            "$mainMod SHIFT, 5, movetoworkspace, 5"
            "$mainMod SHIFT, 6, movetoworkspace, 6"
            "$mainMod SHIFT, 7, movetoworkspace, 7"
            "$mainMod SHIFT, 8, movetoworkspace, 8"
            "$mainMod SHIFT, 9, movetoworkspace, 9"
            "$mainMod SHIFT, 0, movetoworkspace, 10"
            "$mainMod SHIFT, C, movetoworkspace, name:bedroom"
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"
          ];
        };
      };
      programs = {
        fuzzel = {
          enable = true;
        };
        hyprlock = {
          enable = true; # Lock screen for Hyprland
        };
        hyprpanel = {
          enable = true;
          # theme = {
          #   # https://github.com/Jas-SinghFSU/HyprPanel/blob/2c0c66a8ddcdff69b2ff694fefbcd8df4387a9e7/themes/catppuccin_mocha_vivid.json
          # };
          settings = {
            menus = {
              clock = {
                weather.enabled = false;
              };
              dashboard = {
                directories.enabled = false;
                shortcuts.enabled = false;
                controls.enabled = false;
              };
            };
            theme = {
              osd = {
                orientation = "horizontal";
                location = "bottom";
              };
              font = {
                name = "GeistMono Nerd Font";
                #style = "Bold";
                label = "GeistMono Nerd Font Bold";
                weight = 600;
                size = "1rem";
              };
              bar = {
                transparent = true;
              };
            };
            bar = {
              launcher.icon = " ";
              workspaces = {
                show_numbered = true;
              };
              layouts = {
                "*" = {
                  left = [
                    "dashboard"
                    "clock"
                    "windowtitle"
                  ];
                  middle = [ "workspaces" ];
                  right = [
                    "volume"
                    "network"
                    "bluetooth"
                    "notifications"
                    "systray"
                  ];
                };
              };
            };
          };
        };
        cava = {
          enable = true; # Audio visualizer
        };
      };
      services = {
        hyprpaper = {
          enable = true;
          settings = {
            #preload = /home/saik/Pictures/HDR/crater_town_3440x1440.jpg
            #preload = /home/saik/Pictures/HDR/crater_town_2560x1440.jpg
            #
            #wallpaper = desc:AOC Q27G3XMN, /home/saik/Pictures/HDR/crater_town_2560x1440.jpg
            #wallpaper = desc:AOC U34G2G4R3, /home/saik/Pictures/HDR/crater_town_3440x1440.jpg
            preload = [
              "/home/saik/.config/home-manager/assets/wallpapers/crater_town_2560x1440.jpg"
              "/home/saik/.config/home-manager/assets/wallpapers/crater_town_3440x1440.jpg"
            ];
            wallpaper = [
              "desc:AOC Q27G3XMN, /home/saik/.config/home-manager/assets/wallpapers/crater_town_2560x1440.jpg"
              "desc:AOC U34G2G4R3, /home/saik/.config/home-manager/assets/wallpapers/crater_town_3440x1440.jpg"
            ];
          };
        };
        hyprpolkitagent = {
          enable = true; # Polkit agent for Hyprland
        };
        hypridle = {
          enable = true; # Hyprland idle detection
          settings = {
            general = {
              lock_cmd = "pidof hyprlock || hyprlock";
              before_sleep_cmd = "loginctl lock-session";
              after_sleep_cmd = "hyprctl dispatch dpms on";
            };
            listener = [
              {
                timeout = 300; # 5 minutes
                on-timeout = "brightnessctl -s set 10";
                on-resume = "brightnessctl -r";
              }
              {
                timeout = 600; # 10 minutes
                on-timeout = "loginctl lock-session";
              }
              {
                timeout = 900; # 15 minutes
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on";
              }
              {
                timeout = 1800; # 30 minutes
                on-timeout = "systemctl suspend";
              }
            ];
          };
        };
      };
    })
  ];
}
