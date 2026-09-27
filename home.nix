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

    blender_5_0
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

    nixd
    nixfmt

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
    (retroarch.withCores (
      cores: with cores; [
        bsnes
        mupen64plus
        mgba
        beetle-psx-hw
      ]
    ))
    ppsspp-sdl-wayland
    melonds
    pcsx2
    flycast

    luanti
    airshipper
    prismlauncher
    osu-lazer

    musescore

    (llama-cpp.override {
      cudaSupport = true;
    })
  ];

  fonts.fontconfig.enable = true;

  xdg = {
    enable = true;
    userDirs.enable = true;
    systemDirs.data = [
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
      "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
    ];
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
        move-to-center = [ "<Alt>w" ];
        switch-applications = [ ];
        switch-windows = [ "<Alt>Tab" ];
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
        battery-status = "upower -i /org/freedesktop/UPower/devices/battery_BAT1";
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

    librewolf = {
      enable = true;
      enableGnomeExtensions = true;

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
            lines = 22;
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

    zed-editor = {
      enable = true;
      extensions = [
        "toml"
        "nix"
      ];

      userSettings = {
        disable_ai = true;
        bottom_dock_layout = "contained";
        preview_tabs = {
          enable_preview_file_from_code_navigation = true;
          enable_preview_from_project_panel = true;
          enabled = true;
        };
        tabs = {
          git_status = false;
        };
        tab_bar = {
          show = true;
        };
        title_bar = {
          show_menus = false;
          show_worktree_name = true;
        };
        project_panel = {
          dock = "right";
          button = true;
        };
        buffer_font_family = "Iosevka";
        terminal = {
          font_family = "Iosevka";
        };
        telemetry = {
          diagnostics = false;
          metrics = false;
          anthropic_retention = false;
        };
        vim_mode = true;
        base_keymap = "Emacs";
        ui_font_size = 16;
        buffer_font_size = 15;
        theme = {
          mode = "system";
          light = "One Light";
          dark = "One Dark";
        };
      };

      userKeymaps = [
        {
          context = "Workspace";

          bindings = {
            # "shift shift" = "file_finder::Toggle";
          };
        }

        {
          context = "Editor && vim_mode == insert";

          bindings = {
            # "j k" = "vim::NormalBefore";
          };
        }

        {
          context = "Editor && !menu";

          bindings = {
            "ctrl-x 2" = "pane::SplitDown";
            "ctrl-x 3" = "pane::SplitRight";
            "ctrl-x o" = "workspace::ActivateNextPane";
            "ctrl-x 0" = "pane::CloseActiveItem";
            "ctrl-x 1" = "pane::CloseOtherItems";
          };
        }
      ];
    };

    vscodium = {
      enable = true;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          ms-vscode-remote.remote-ssh
          vscodevim.vim
          mkhl.direnv
          jnoortheen.nix-ide
          rust-lang.rust-analyzer
          shd101wyy.markdown-preview-enhanced
        ];

        userSettings = {
          "editor.fontFamily" = "'Iosevka'";
          "editor.fontSize" = 16;
          "terminal.integrated.fontSize" = 16;

          "workbench.startupEditor" = "none";
          "workbench.colorTheme" = "Tomorrow Night Blue";
          "window.autoDetectColorScheme" = true;
          "workbench.preferredDarkColorTheme" = "Tomorrow Night Blue";

          "vim.useSystemClipboard" = true;
          "vim.useCtrlKeys" = true;
          "vim.handleKeys" = {
            "<C-x>" = false;
            "<C-g>" = false;
          };

          "files.insertFinalNewline" = true;
          "notebook.insertFinalNewline" = true;

          "editor.rulers" = [
            100
          ];

          "window.newWindowDimensions" = "fullscreen";
          "window.restoreFullscreen" = true;

          "workbench.activityBar.location" = "hidden";

          "security.workspace.trust.untrustedFiles" = "open";

          "editor.minimap.enabled" = false;
          "breadcrumbs.enabled" = false;
          "editor.codeLens" = false;
          "editor.inlayHints.enabled" = "off";
          "terminal.integrated.initialHint" = false;
          "terminal.integrated.commandsToSkipShell" = [
            "workbench.action.focusLeftGroup"
            "workbench.action.focusRightGroup"
            "workbench.action.focusAboveGroup"
            "workbench.action.focusBelowGroup"
          ];

          "editor.stickyScroll.enabled" = false;
          "zenMode.hideStatusBar" = false;
          "zenMode.hideLineNumbers" = false;

          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
        };

        keybindings = [
          {
            key = "ctrl+x 2";
            command = "workbench.action.splitEditorDown";
          }

          {
            key = "ctrl+x 3";
            command = "workbench.action.splitEditorRight";
          }

          {
            key = "ctrl+x o";
            command = "workbench.action.navigateEditorGroups";
          }

          {
            key = "ctrl+x 0";
            command = "workbench.action.closeEditorsAndGroup";
          }

          {
            key = "ctrl+x 1";
            command = "workbench.action.joinAllGroups";
          }

          {
            key = "ctrl+x k";
            command = "workbench.action.closeActiveEditor";
          }

          {
            key = "ctrl+x ctrl+f";
            command = "workbench.action.quickOpen";
          }

          {
            key = "ctrl+x ctrl+c";
            command = "workbench.action.closeWindow";
          }

          {
            key = "ctrl+x b";
            command = "workbench.action.showAllEditors";
          }

          {
            key = "ctrl+x ctrl+b";
            command = "workbench.action.showAllEditors";
          }

          {
            key = "alt+x";
            command = "workbench.action.showCommands";
          }

          {
            key = "ctrl+left";
            command = "workbench.action.focusLeftGroup";
            when = "editorTextFocus || terminalFocus";
          }

          {
            key = "ctrl+right";
            command = "workbench.action.focusRightGroup";
            when = "editorTextFocus || terminalFocus";
          }

          {
            key = "ctrl+up";
            command = "workbench.action.focusAboveGroup";
            when = "editorTextFocus || terminalFocus";
          }

          {
            key = "ctrl+down";
            command = "workbench.action.focusBelowGroup";
            when = "editorTextFocus || terminalFocus";
          }

          {
            key = "ctrl+g";
            command = "workbench.action.closeQuickOpen";
            when = "inQuickOpen";
          }

          {
            key = "ctrl+g";
            command = "closeFindWidget";
            when = "findWidgetVisible";
          }

          {
            key = "ctrl+g";
            command = "extension.vim_escape";
            when = "vim.active && vim.mode == 'CommandlineInProgress'";
          }

          {
            key = "ctrl+g";
            command = "extension.vim_escape";
            when = "vim.active && vim.mode == 'SearchInProgressMode'";
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

  # Add Firefox GNOME theme directory
  home.file."librewolf-gnome-theme" = {
    target = ".librewolf/default/chrome/firefox-gnome-theme";
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
