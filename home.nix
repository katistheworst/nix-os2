{ config, pkgs, inputs, lib, ... }:

{
  home.username = "kat";
  home.homeDirectory = "/home/kat";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  # ── Ghostty Terminal ──────────────────────────────────────────────
  programs.ghostty = {
    enable = true;
    # Stylix will auto-theme Ghostty's colors. Add your own overrides:
    settings = {
      font-family = "Maple Mono NF";
      font-size = 13;
      window-padding-x = 12;
      window-padding-y = 12;
      window-decoration = false;
      confirm-close-surface = false;
      cursor-style = "bar";
      cursor-style-blink = true;
      mouse-hide-while-typing = true;
      background-opacity = 0.85;   # glass transparency 🪟
      # minimum-contrast = 1.1;    # uncomment if text is hard to read
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
      cc = "claude";  # Claude Code shortcut
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
      # 🎀 Princess Bubblegum Rice Theme — powerline gradient
      format = ''
        [](fg:#ff69b4)$os[](bg:#ff1493 fg:#ff69b4)$username[](bg:#c71585 fg:#ff1493)$directory[](bg:#9932cc fg:#c71585)$git_branch$git_status[](bg:#6a0dad fg:#9932cc)$python$conda[](fg:#6a0dad)$fill[](fg:#8b008b)$cmd_duration[](bg:#9400d3 fg:#8b008b)$battery[](bg:#ba55d3 fg:#9400d3)$time[ ](fg:#ba55d3)
        $character'';
      add_newline = true;

      fill.symbol = " ";

      character = {
        success_symbol = "[❯](bold #d94fa0)";
        error_symbol = "[❯](bold #ff6b9d)";
      };

      os = {
        style = "bg:#ff69b4 fg:white bold";
        disabled = false;
        format = "[ $symbol ]($style)";
      };
      os.symbols = {
        NixOS = "❄️";
        Linux = "🐧";
      };

      username = {
        style_user = "bg:#ff1493 fg:white bold";
        style_root = "bg:#ff1493 fg:red bold";
        format = "[ $user ]($style)";
        show_always = true;
      };

      directory = {
        style = "bg:#c71585 fg:white bold";
        format = "[ $path ]($style)";
        truncation_length = 5;
        truncation_symbol = "…/";
      };

      git_branch = {
        style = "bg:#9932cc fg:white bold";
        format = "[ $symbol$branch ]($style)";
        symbol = " ";
      };
      git_status = {
        style = "bg:#9932cc fg:white bold";
        format = "[$all_status$ahead_behind]($style)";
      };

      python = {
        style = "bg:#6a0dad fg:white";
        format = "[ $symbol$version ]($style)";
        symbol = " ";
      };

      cmd_duration = {
        style = "bg:#8b008b fg:white";
        format = "[ 󱎫 $duration ]($style)";
        min_time = 1000;
      };

      battery = {
        display = [
          { threshold = 30; style = "bg:#9400d3 fg:red bold"; }
        ];
        format = "[ $symbol$percentage ]($style)";
      };
      battery.charging_symbol = "⚡";
      battery.discharging_symbol = "🔋";
      battery.full_symbol = "💚";

      time = {
        disabled = false;
        style = "bg:#ba55d3 fg:white bold";
        format = "[ 🩷 $time ]($style)";
        time_format = "%H:%M";
      };
    };
  };

  # ── Git ───────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    userName = "Kat";       # change to your git name
    userEmail = "";          # add your email
  };

  # ── Zen Browser ────────────────────────────────────────────────────
  # Zen is a Firefox fork — install via flatpak or from flake
  # For now, keep firefox as fallback; install Zen manually after first boot:
  #   flatpak install flathub app.zen_browser.zen
  programs.firefox.enable = true;  # fallback until Zen is set up

  # ── Hyprland ──────────────────────────────────────────────────────
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # ── Monitor ─────────────────────────────────────────────────
      monitor = [ ",preferred,auto,1" ];

      # ── General ─────────────────────────────────────────────────
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        # Stylix handles colors, but you can override:
        # "col.active_border" = "rgb(d94fa0) rgb(a86fbf) 45deg";
        # "col.inactive_border" = "rgb(2d1f2e)";
        layout = "dwindle";
      };

      # ── Decoration (glass effect ✨) ─────────────────────────────
      decoration = {
        rounding = 12;
        active_opacity = 0.92;
        inactive_opacity = 0.82;
        fullscreen_opacity = 1.0;
        blur = {
          enabled = true;
          size = 8;
          passes = 4;
          new_optimizations = true;
          ignore_opacity = true;   # blur works even with transparent windows
          noise = 0.015;
          contrast = 1.0;
          brightness = 0.95;
          vibrancy = 0.2;
          vibrancy_darkness = 0.3;
          popups = true;
        };
        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
          color = "rgba(1a101660)";
        };
      };

      # ── Window Rules (glass + blur) ─────────────────────────────
      windowrulev2 = [
        # Make terminal extra glassy
        "opacity 0.88 0.78, class:^(com.mitchellh.ghostty)$"
        # Cursor IDE — slightly glassy
        "opacity 0.92 0.85, class:^(cursor)$"
        "opacity 0.92 0.85, class:^(Cursor)$"
        # Firefox stays opaque for readability
        "opacity 1.0 0.95, class:^(firefox)$"
        "opacity 1.0 0.95, class:^(zen-alpha)$"
      ];

      # ── Layer Rules (blur Noctalia, notifications) ──────────────
      layerrule = [
        "blur, notifications"
        "blur, gtk-layer-shell"
      ];

      # ── Animations ──────────────────────────────────────────────
      animations = {
        enabled = true;
        bezier = [
          "ease, 0.25, 0.1, 0.25, 1"
          "snappy, 0.4, 0, 0.2, 1"
        ];
        animation = [
          "windows, 1, 5, snappy, slide"
          "windowsOut, 1, 5, snappy, slide"
          "fade, 1, 4, ease"
          "workspaces, 1, 4, snappy, slide"
        ];
      };

      # ── Input ───────────────────────────────────────────────────
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
        sensitivity = 0;
      };

      # ── Dwindle Layout ──────────────────────────────────────────
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # ── NVIDIA-specific ─────────────────────────────────────────
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

      # ── Autostart ───────────────────────────────────────────────
      exec-once = [
        "noctalia-shell"   # start Noctalia desktop shell
        "hypridle"         # auto-lock daemon
        "wl-paste --watch cliphist store"  # clipboard history daemon
        "wlsunset -l 47.6 -L -122.3"      # night light (Seattle coords)
        # "eww open bar"   # uncomment when you have an Eww config
      ];

      # ── Keybinds ────────────────────────────────────────────────
      "$mod" = "SUPER";

      bind = [
        # Apps
        "$mod, Return, exec, ghostty"
        "$mod, E, exec, ghostty -e yazi"
        "$mod, B, exec, firefox"
        "$mod, C, exec, cursor"

        # Noctalia launcher (IPC call)
        "$mod, D, exec, noctalia-shell ipc call launcher toggle"

        # Screenshots (hyprshot)
        "$mod, S, exec, hyprshot -m region"
        "$mod SHIFT, S, exec, hyprshot -m output"
        "$mod ALT, S, exec, hyprshot -m window"

        # Lock screen
        "$mod, escape, exec, hyprlock"

        # Window management
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

        # Move to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        # Scroll through workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      # Mouse binds
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Volume & brightness (fn keys)
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

  # ── Hyprlock (lock screen) ──────────────────────────────────────
  programs.hyprlock = {
    enable = true;
    settings = {
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
        outer_color = "rgb(d94fa0)";       # magenta border
        inner_color = "rgb(1a1016)";       # dark bg
        font_color = "rgb(f0d0e8)";        # pink white text
        fade_on_empty = true;
        placeholder_text = "<i>  Enter Password...</i>";
        hide_input = false;
        position = "0, -80";
        halign = "center";
        valign = "center";
      }];

      label = [
        {
          # Time — big pixel clock
          monitor = "";
          text = "$TIME";
          color = "rgb(e060b0)";           # bubblegum pink
          font_size = 96;
          font_family = "Pixelify Sans";
          position = "0, 120";
          halign = "center";
          valign = "center";
        }
        {
          # Date
          monitor = "";
          text = "cmd[update:3600000] date '+%A, %B %d'";
          color = "rgb(c77dba)";           # orchid
          font_size = 22;
          font_family = "Pixelify Sans";
          position = "0, 50";
          halign = "center";
          valign = "center";
        }
        {
          # Rotating Money Affirmations 💸
          monitor = "";
          text = ''cmd[update:30000] shuf -n1 ~/.config/hypr/affirmations.txt'';
          color = "rgb(a86fbf)";           # lavender
          font_size = 16;
          font_family = "Pixelify Sans";
          position = "0, -140";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # ── Hypridle (auto-lock) ──────────────────────────────────────────
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
          # Dim screen after 5 min
          timeout = 300;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          # Lock after 10 min
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          # Screen off after 15 min
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  # ── Yazi (terminal file manager) ──────────────────────────────────
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.eww = {
    enable = true;
    configDir = ./eww;  # create this folder with your eww config later
  };

  # ── Packages (user-level) ─────────────────────────────────────────
  home.packages = with pkgs; [
    # Dev tools
    neovim
    lazygit
    fzf
    eza       # modern ls
    bat       # modern cat
    jq
    nodejs    # needed for Claude Code and OpenClaw
    claude-code  # Anthropic's agentic coding CLI

    # Screenshots
    hyprshot

    # fGalaxy (directory constellation visualizer)
    # Install manually: curl -sSL https://raw.githubusercontent.com/xoodymoon/fgalaxy/main/install.sh | bash
    python3
    python3Packages.numpy

    # Fonts (extra — Stylix handles main fonts via configuration.nix)
    maple-mono.NF           # terminal/code font (Nerd Font glyphs)
    noto-fonts-color-emoji  # emoji support 🩷
    # Pixelify Sans is packaged as a custom derivation in configuration.nix

    # Fun
    cava      # audio visualizer
    pipes-rs  # terminal screensaver
  ];

  # ── XDG ───────────────────────────────────────────────────────────
  xdg.enable = true;

  # ── Affirmations file (used by Hyprlock greeting + zsh) ───────────
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

  # ── NSO Desktop Icons (Needy Streamer Overload) ─────────────────
  # Fetched from: github.com/lezzthanthree/Needy-Streamer-Overload
  # Use these as custom desktop/launcher icons in Noctalia or Eww
  # Path: ~/.local/share/icons/nso/
  home.file.".local/share/icons/nso" = {
    source = ./icons/nso;
    recursive = true;
  };
}
