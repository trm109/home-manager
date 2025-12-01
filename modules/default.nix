{ pkgs, ... }:
{
  imports = [
    ./graphical
    ./terminal
  ];
  home.packages = with pkgs; [
    geist-font
    nerd-fonts.geist-mono # monospace, sans-serif
    ibm-plex
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    liberation_ttf # fallback, proton wants??
    corefonts
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [
        "GeistMono Nerd Font"
        "IBM Plex Mono"
      ];
      sansSerif = [
        "Geist"
        "IBM Plex Sans"
      ];
      serif = [
        "IBM Plex Serif"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
