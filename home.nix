{ config, pkgs, inputs, lib, ... }:

{
  home.username = "kat";
  home.homeDirectory = "/home/kat";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  # ── AGS (Aylur's GTK Shell) ──────────────────────────────────────
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;
    # configDir managed manually in ~/.config/ags
    extraPackages = [
      inputs.ags.packages.x86_64-linux.hyprland
      inputs.ags.packages.x86_64-linux.battery
      inputs.ags.packages.x86_64-linux.wireplumber
      inputs.ags.packages.x86_64-linux.network
      inputs.ags.packages.x86_64-linux.apps
    ];
  };

  # ── Ghostty Terminal ──────────────────────────────────────────────
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-size = 13;
      window-padding-x = 12;
      window-padding-y = 12;
      window-decoration = false;
      confirm-close-surface = false;
      cursor-style = "bar";
      cursor-style-blink = true;
      mouse-hide-while-typing = true;
      background-opacity = 0.6;
      minimum-contrast = 1.1;
    };
  };

  # ── Zsh ───────────────────────────────────────────────────────────
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "eza -la --icons";
      ls = "eza --icons";
      cat = "bat";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#tuf";
      update = "nix flake update --flake ~/nixos-config";
      cc = "claude";
    };
    initExtra = ''
      # 💸 Money affirmation on each new shell
      if [[ -f ~/.config/hypr/affirmations.txt ]]; then
        echo ""
        echo -e "\033[1;35m$(shuf -n1 ~/.config/hypr/affirmations.txt)\033[0m"
        echo ""
      fi
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" ];
    };
  };

  # ── Starship Prompt ───────────────────────────────────────────────
  programs.starship = {
    enable = true;
    settings = {
      format = ''
        [](fg:#C4838B)$os[](bg:#B06B72 fg:#C4838B)$username[](bg:#8B5E6B fg:#B06B72)$directory[](bg:#6B4F5A fg:#8B5E6B)$git_branch$git_status[](bg:#5A3F4E fg:#6B4F5A)$python$conda[](fg:#5A3F4E)$fill[](fg:#5A3F4E)$cmd_duration[](bg:#6B4F5A fg:#5A3F4E)$battery[](bg:#8B5E6B fg:#6B4F5A)$time[ ](fg:#8B5E6B)
        $character'';
      add_newline = true;
      fill.symbol = " ";

      character = {
        success_symbol = "[❯](bold #C4838B)";
        error_symbol = "[❯](bold #D4A5A5)";
      };

      os = {
        style = "bg:#C4838B fg:#F5F0EB bold";
        disabled = false;
        format = "[ $symbol ]($style)";
      };
      os.symbols = {
        NixOS = "❄️";
        Linux = "🐧";
      };

      username = {
        style_user = "bg:#B06B72 fg:#F5F0EB bold";
        style_root = "bg:#B06B72 fg:red bold";
        format = "[ $user ]($style)";
        show_always = true;
      };

      directory = {
        style = "bg:#8B5E6B fg:#F5F0EB bold";
        format = "[ $path ]($style)";
        truncation_length = 5;
        truncation_symbol = "…/";
      };

      git_branch = {
        style = "bg:#6B4F5A fg:#F5F0EB bold";
        format = "[ $symbol$branch ]($style)";
        symbol = " ";
      };
      git_status = {
        style = "bg:#6B4F5A fg:#F5F0EB bold";
        format = "[$all_status$ahead_behind]($style)";
      };

      python = {
        style = "bg:#5A3F4E fg:#F5F0EB";
        format = "[ $symbol$version ]($style)";
        symbol = " ";
      };

      cmd_duration = {
        style = "bg:#5A3F4E fg:#F5F0EB";
        format = "[ 󱎫 $duration ]($style)";
        min_time = 1000;
      };

      battery = {
        display = [
          { threshold = 30; style = "bg:#6B4F5A fg:red bold"; }
        ];
        format = "[ $symbol$percentage ]($style)";
      };
      battery.charging_symbol = "⚡";
      battery.discharging_symbol = "🔋";
      battery.full_symbol = "💚";

      time = {
        disabled = false;
        style = "bg:#8B5E6B fg:#F5F0EB bold";
        format = "[ 🩷 $time ]($style)";
        time_format = "%H:%M";
      };
    };
  };

  # ── Git ───────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    userName = "Kat";
    userEmail = "";
  };

  # ── Firefox ───────────────────────────────────────────────────────
  programs.firefox.enable = true;

  # ── Eww Widgets ───────────────────────────────────────────────────
  programs.eww = {
    enable = true;
    configDir = ./eww;
  };

  # ── Hyprland ──────────────────────────────────────────────────────
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [ ",preferred,auto,1" ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = lib.mkForce "rgb(C4838B) rgb(B06B72) 45deg";
        "col.inactive_border" = lib.mkForce "rgb(2d1f2e)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 12;
        active_opacity = 0.92;
        inactive_opacity = 0.80;
        fullscreen_opacity = 1.0;
        blur = {
          enabled = true;
          size = 10;
          passes = 5;
          new_optimizations = true;
          ignore_opacity = true;
          noise = 0.01;
          contrast = 1.0;
          brightness = 0.9;
          vibrancy = 0.3;
          vibrancy_darkness = 0.4;
          popups = true;
        };
        shadow = {
          enabled = true;
          range = 25;
          render_power = 3;
        };
      };

      # windowrules moved to extraConfig for 0.53 compat

      # layerrules disabled — Hyprland 0.53 syntax issue
      # Re-enable when AGS layers are running

      animations = {
        enabled = true;
        bezier = [
          "ease, 0.25, 0.1, 0.25, 1"
          "snappy, 0.4, 0, 0.2, 1"
          "smooth, 0.05, 0.9, 0.1, 1.05"
        ];
        animation = [
          "windows, 1, 5, snappy, slide"
          "windowsOut, 1, 5, snappy, slide"
          "fade, 1, 4, ease"
          "workspaces, 1, 4, snappy, slide"
          "layers, 1, 3, smooth, fade"
        ];
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
        sensitivity = 0;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
      ];

      cursor = {
        no_hardware_cursors = true;
      };

      exec-once = [
        "ags run &"
        "hypridle"
        "wl-paste --watch cliphist store"
        "wlsunset -l 34.0 -L -118.2"
      ];

      "$mod" = "SUPER";

      bind = [
        # Apps
        "$mod, Return, exec, ghostty"
        "$mod, E, exec, ghostty -e yazi"
        "$mod, B, exec, firefox"
        "$mod, C, exec, cursor"
        "$mod, D, exec, ags toggle launcher"
        "$mod, slash, exec, ags toggle cheatsheet"
        "$mod, x, exec, ags toggle powermenu"
        " SHIFT, V, exec, cliphist list | rofi -dmenu -p clipboard | cliphist decode | wl-copy"

        # Screenshots
        "$mod, S, exec, hyprshot -m region"
        "$mod SHIFT, S, exec, hyprshot -m output"
        "$mod ALT, S, exec, hyprshot -m window"

        # Lock
        "$mod, escape, exec, hyprlock"

        # Windows
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod, V, togglefloating"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"

        # Focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        # Move windows
        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonitorBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonitorBrightnessDown, exec, brightnessctl set 5%-"
      ];

      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];
    };
  };

  # ── Hyprlock ──────────────────────────────────────────────────────
  programs.hyprlock = {
    enable = true;
    settings = lib.mkForce {
      general = {
        hide_cursor = true;
        grace = 5;
      };

      background = [{
        monitor = "";
        path = "screenshot";
        blur_passes = 4;
        blur_size = 6;
        noise = 0.02;
        brightness = 0.6;
      }];

      input-field = [{
        monitor = "";
        size = "300, 50";
        outline_thickness = 2;
        dots_size = 0.25;
        dots_spacing = 0.3;
        outer_color = "rgb(C4838B)";
        inner_color = "rgb(1a1016)";
        font_color = "rgb(F5F0EB)";
        fade_on_empty = true;
        placeholder_text = "<i>  Enter Password...</i>";
        hide_input = false;
        position = "0, -80";
        halign = "center";
        valign = "center";
      }];

      label = [
        {
          # Kangel icon
          monitor = "";
          text = "";
          color = "rgb(C4838B)";
          font_size = 1;
          font_family = "Inter";
          position = "0, 220";
          halign = "center";
          valign = "center";
        }
        {
          # Greeting
          monitor = "";
          text = "hi kat 🩷";
          color = "rgb(B06B72)";
          font_size = 18;
          font_family = "Inter";
          position = "0, 180";
          halign = "center";
          valign = "center";
        }
        {
          # Time
          monitor = "";
          text = "$TIME";
          color = "rgb(C4838B)";
          font_size = 96;
          font_family = "Inter";
          position = "0, 100";
          halign = "center";
          valign = "center";
        }
        {
          # Date
          monitor = "";
          text = ''cmd[update:3600000] date '+%A, %B %d' '';
          color = "rgb(B06B72)";
          font_size = 22;
          font_family = "Inter";
          position = "0, 30";
          halign = "center";
          valign = "center";
        }
        {
          # Affirmation
          monitor = "";
          text = "cmd[update:30000] shuf -n1 ~/.config/hypr/affirmations.txt";
          color = "rgb(D4A5A5)";
          font_size = 16;
          font_family = "Inter";
          position = "0, -150";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # ── Hypridle ──────────────────────────────────────────────────────
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  # ── Yazi ──────────────────────────────────────────────────────────
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  # ── Packages ──────────────────────────────────────────────────────
  home.packages = with pkgs; [
    rofi

    # Dev tools
    neovim
    lazygit
    fzf
    eza
    bat
    jq
    nodejs

    # Screenshots
    hyprshot

    # Python
    python3
    python3Packages.numpy

    # Fonts
    noto-fonts-color-emoji

    # Fun
    cava
    pipes-rs
  ];

  # ── XDG ───────────────────────────────────────────────────────────
  xdg.enable = true;
  # ── Cursor Theme ─────────────────────────────────────────────────
  home.pointerCursor = {
    name = lib.mkForce "RoseHeartCursor";
    package = lib.mkForce (pkgs.callPackage ./cursors {});
    size = lib.mkForce 24;
    gtk.enable = true;
  };

  # ── Affirmations ──────────────────────────────────────────────────
  home.file.".config/hypr/affirmations.txt".text = ''
    I deserve to receive large sums of money 💰
    My voice is a powerful tool that conveys confidence, value, and conviction
    Every no is an exercise that makes me stronger and gets me closer to a yes
    My confidence is contagious, and I project it effortlessly through the phone
    I have the discipline and determination to make every call count
    I am a natural expert in my product, and my enthusiasm is impossible to ignore
    I release any negative energy from my last call and welcome the next opportunity with a fresh mindset
    Rejection is not personal; it is simply a signpost guiding me to the customers who need my help the most
    I remain calm and professional in the face of objections, and my empathy disarms negativity
    I am an action-taker, and every call and message I send creates momentum toward my goals
    I use my time effectively and make every dial with purpose and focus
    I am well-compensated for my activity, and my hard work directly results in abundance
    I focus on activity, not results, because consistent action always produces success
    I am attracting my perfect customers effortlessly and consistently
    Money flows to me easily and frequently
    I am worthy of financial abundance
    I am a magnet for wealth and prosperity
  '';

  # ── NSO Icons ─────────────────────────────────────────────────────
  home.file.".local/share/icons/nso" = {
    source = ./icons/nso;
    recursive = true;
  };
}
