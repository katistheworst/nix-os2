{ config, pkgs, inputs, lib, ... }:

let
  # Pixelify Sans — kawaii pixel font from Google Fonts
  # If the hash is wrong on first build, Nix will tell you the correct one.
  # Just replace it with the hash from the error message.
  pixelify-sans = pkgs.stdenvNoCC.mkDerivation {
    pname = "pixelify-sans";
    version = "1.003";
    src = pkgs.fetchzip {
      url = "https://fonts.google.com/download?family=Pixelify+Sans";
      extension = "zip";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";  # replace on first build!
      stripRoot = false;
    };
    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      find $src -name '*.ttf' -exec cp {} $out/share/fonts/truetype/ \;
    '';
    meta = {
      description = "Pixelify Sans — pixel display font from Google Fonts";
      license = lib.licenses.ofl;
    };
  };
in

{
  # ── Boot ──────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ── Networking ────────────────────────────────────────────────────
  networking.hostName = "tuf";
  networking.networkmanager.enable = true;

  # ── Locale & Time ─────────────────────────────────────────────────
  time.timeZone = "America/Los_Angeles";  # adjust if needed
  i18n.defaultLocale = "en_US.UTF-8";

  # ── Nix Settings ──────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # ── NVIDIA ────────────────────────────────────────────────────────
  # TUF Gaming 15 typically has NVIDIA + Intel/AMD hybrid graphics
  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;  # use proprietary driver for best Hyprland compat
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # ── Hyprland ──────────────────────────────────────────────────────
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # ── nix-ld (for Cursor/Electron dynamic linking) ────────────────
  programs.nix-ld.enable = true;

  # ── Audio (Pipewire) ─────────────────────────────────────────────
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # Disable PulseAudio since we're using Pipewire
  services.pulseaudio.enable = false;

  # ── Bluetooth ─────────────────────────────────────────────────────
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # ── Display Manager ───────────────────────────────────────────────
  # greetd is lightweight and works well with Hyprland
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # ── Stylix (system-wide theming) ──────────────────────────────────
  # Princess Bubblegum inspired pink/magenta/purple palette
  stylix = {
    enable = true;
    # LaserAway illustration wallpaper (upscaled 4x)
    image = ./wallpaper.png;
    # Keep the custom PB palette instead of auto-generating from wallpaper:
    base16Scheme = {
      base00 = "1a1016";  # background - deep plum black
      base01 = "2d1f2e";  # lighter bg
      base02 = "3d2b3f";  # selection
      base03 = "6b4f6e";  # comments
      base04 = "c299b5";  # dark fg
      base05 = "f0d0e8";  # foreground - soft pink white
      base06 = "f8e0f0";  # light fg
      base07 = "fff0fa";  # lightest fg
      base08 = "ff6b9d";  # red/error - hot pink
      base09 = "ff8cc6";  # orange - rose
      base0A = "ffb3d9";  # yellow - light pink
      base0B = "c77dba";  # green - orchid purple
      base0C = "a86fbf";  # cyan - lavender
      base0D = "d94fa0";  # blue - magenta
      base0E = "e060b0";  # purple - bubblegum pink
      base0F = "8b5e83";  # brown - muted plum
    };

    # If you have a wallpaper, uncomment and set the path:
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-simple-dark-gray.png";
      sha256 = "1mcr2d1r67i8bch3npwfd3jb4ildi68wnz7yjpjkn7faa2gng3v8";
    };
    # Replace with your own wallpaper later ^^

    polarity = "dark";

    fonts = {
      monospace = {
        package = pkgs.maple-mono.NF;
        name = "Maple Mono NF";
      };
      sansSerif = {
        package = pixelify-sans;
        name = "Pixelify Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      sizes = {
        applications = 11;
        terminal = 13;
      };
    };
  };

  # ── System Packages ───────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Core utils
    git
    wget
    curl
    unzip
    ripgrep
    fd
    btop
    neofetch

    # Wayland essentials
    wl-clipboard
    xdg-utils
    xdg-desktop-portal-hyprland

    # AI IDE
    code-cursor

    # Screenshots
    grim
    slurp

    # Brightness
    brightnessctl

    # Noctalia dependencies
    cliphist      # clipboard history
    wlsunset      # night light

    # Lock screen
    hyprlock
    hypridle

    # Noctalia shell (from flake)
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # ── User ──────────────────────────────────────────────────────────
  users.users.kat = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # ── Security ──────────────────────────────────────────────────────
  security.polkit.enable = true;
  security.rtkit.enable = true;  # for Pipewire

  # ── NVIDIA env vars for Hyprland ──────────────────────────────────
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
  };

  system.stateVersion = "24.11";  # match your installer version
}
