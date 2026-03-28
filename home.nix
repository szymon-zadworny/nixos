{ pkgs, firefox-gnome-theme, ... }: {
  home.packages = with pkgs; [
    gnomeExtensions.blur-my-shell
    gnomeExtensions.hide-top-bar
    gnomeExtensions.gsconnect
    gnomeExtensions.appindicator
    gnomeExtensions.wiggle
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.tiling-assistant
    gnomeExtensions.kimpanel
    gnomeExtensions.transparent-top-bar-adjustable-transparency
    gnomeExtensions.legacy-gtk3-theme-scheme-auto-switcher

    numix-icon-theme-circle

    dconf-editor
    gnome-tweaks

    blender
    krita
    gimp3
    godot
    obs-studio
    python314
    uv
    octaveFull
    texliveFull

    ffmpeg-full
    imagemagick
    onlyoffice-desktopeditors
    papers
    foliate

    mpv
    showtime

    vesktop
    fractal
    spotify
    audacious
    ncmpcpp
    cmus
    fastfetch
    pfetch
    blackbox-terminal
    transmission_4-gtk

    radare2
    ghidra-bin

    dolphin-emu

    iosevka-bin
    (iosevka-bin.override { variant = "Aile"; })
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    ripgrep
    tokei

    wineWow64Packages.stagingFull
    lutris
    bottles
    (retroarch.withCores (cores: with cores; [
      bsnes
      mupen64plus
      mgba
      beetle-psx-hw
    ]))
    ppsspp-sdl-wayland
    melonds

    xonotic
    luanti
    airshipper
    prismlauncher
    osu-lazer

    musescore
  ];

  fonts.fontconfig.enable = true;

  xdg = {
    enable = true;
    userDirs.enable = true;
  };

  gtk.enable = true;
  gtk.gtk3 = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/wm/keybindings" = {
    move-to-center = ["<Alt>w"];
    switch-applications = [];
    switch-windows = ["<Alt>Tab"];
  };

  "org/gnome/shell/app-switcher" = {
    current-workspace-only = true;
  };

  "org/gnome/desktop/interface" = {
    icon-theme = "Numix-Circle";
  };

      "org/gnome/desktop/wm/preferences" = {
    button-layout = "close,appmenu:";
  };

      "org/gnome/shell" = {
    enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
          "blur-my-shell@aunetx"
          "gsconnect@andyholmes.github.io"
          "hidetopbar@mathieu.bidon.ca"
          "wiggle@mechtifs"
      "caffeine@patapon.info"
      "clipboard-indicator@tudmotu.com"
      "kimpanel@kde.org"
      "tiling-assistant@leleat-on-github"
      "transparent-top-bar@ftpix.com"
      "legacyschemeautoswitcher@joshimukul29.gmail.com"
    ];
  };

      "org/gnome/shell/extensions/hidetopbar" = {
        enable-active-window = false;
      };

      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        blur = false;
      };

  "com/ftpix/transparentbar" = {
    dark-full-screen = false;
    transparency = 0;
  };
    };
  };

  home.sessionPath = [
    "$HOME/Programs/Scripts"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.rvm/bin"
  ];

  programs = {
    bash = {
      enable = true;

      initExtra = ''
        # include .profile if it exists
        [[ -f ~/.profile ]] && . ~/.profile
      '';

      historyControl = [ "ignorespace" ];

      shellAliases = {
        ls = "ls --color=auto";
        cls = "clear && printf \'\\e[3J\'";
        octave = "octave --silent";
        gdb = "gdb -q";
        battery-status = "upower -i /org/freedesktop/UPower/devices/battery_BAT0";
      };

      sessionVariables = {
        EDITOR = "nvim";
      };
    };

    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    firefox = {
      enable = true;

      profiles.default = {
         name = "Default";
         settings = {
            # For Firefox GNOME theme:
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.tabs.drawInTitlebar" = true;
            "svg.context-properties.content.enabled" = true;
         };
         userChrome = ''
            @import "firefox-gnome-theme/userChrome.css";
            @import "firefox-gnome-theme/theme/colors/dark.css"; 
         '';
  };
    };

    chromium = {
      enable = true;
      commandLineArgs = [
        "--enable-unsafe-webgpu"
        "--enable-features=Vulkan"
      ];
    };

    git = {
        enable = true;
        settings = {
          user.name = "sajmon";
          user.email = "szymon17099@gmail.com";
          init.defaultBranch = "master";
        };
        ignores = [
          ".ccls-cache/"
          ".ccls"
          "\#*"
          "vgcore*"
          "*.[oad]"
          "*.out"
          "*.elf"
          "*.exe"
          "program"
          "*.~undo-tree~"
          "*.obj"
          ".envrc"
          ".direnv/"
        ];
    };

    alacritty = {
      enable = true;
  theme = "gruvbox_dark";
  settings = {
    env = {
      term = "xterm-256color";
    };

    window = {
      dimensions = {
        columns = 90;
        lines= 22;
      };

      opacity = 1.0;

      padding.x = 15;
      padding.y = 15;

      decorations = "Full";
      decorations_theme_variant = "Dark";
    };

    font = {
      normal.family = "Iosevka";
      bold.family = "Iosevka Medium";
      italic.family = "Iosevka";
      bold_italic.family = "Iosevka Medium";
      size = 12.0;
    };

    keyboard.bindings = [
      {
        key = "F11";
        action = "ToggleFullscreen";
      }
    ];
      };
    };
  };

  # Add Firefox GNOME theme directory
  home.file."firefox-gnome-theme" = {
    target = ".mozilla/firefox/default/chrome/firefox-gnome-theme";
    source = firefox-gnome-theme;
  };

  # This value determines the Home Manager release that your configuration is 
  # compatible with. This helps avoid breakage when a new Home Manager release 
  # introduces backwards incompatible changes. 
  #
  # You should not change this value, even if you update Home Manager. If you do 
  # want to update the value, then make sure to first check the Home Manager 
  # release notes. 
  home.stateVersion = "24.05"; # Please read the comment before changing. 
}
