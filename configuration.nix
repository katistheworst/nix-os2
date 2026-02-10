{ config, pkgs, inputs, lib, ... }:

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

  # ── SSH ───────────────────────────────────────────────────────────
  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ]; 
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
  # Palette auto-generated from wallpaper — picks up the pinks,
  # blush, cream, and warm tones from the LaserAway illustration
  stylix = {
    enable = true;
    image = ./wallpaper.png;
    polarity = "light";

    cursor = {
      package = pkgs.callPackage ./cursors {};
      name = "RoseHeartCursor";
      size = 24;
    };

    opacity = {
      applications = 0.92;
      terminal = 0.65;
      desktop = 0.85;
      popups = 0.9;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
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

  # ── Plymouth (boot splash) ──────────────────────────────────────
  boot.plymouth = {
    enable = true;
    theme = lib.mkForce "bgrt";
  };
  boot.initrd.systemd.enable = true;

  system.stateVersion = "24.11";  # match your installer version
}
