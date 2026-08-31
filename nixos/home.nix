{ config, pkgs, pkgs-stable, inputs, lib, ... }:

{
  home.stateVersion = "26.05"; # меняй на свою когда будет ставить первый раз

  # ============================================================
  # Home Packages
  # ============================================================

  home.packages = with pkgs; [
    basedpyright
  ];

  # ============================================================
  # Gaming
  # ============================================================

  programs.lutris.enable = true;

  # ============================================================
  # GTK
  # ============================================================

  #gtk.gtk4.theme = null;

  # ============================================================
  # KDE Plasma
  # ============================================================

  xdg.configFile."plasma-localerc" = {
    force = true;
    text = ''
      [Formats]
      LANG=ru_RU.UTF-8

      [Translations]
      LANGUAGE=ru_RU
    '';
  };

  xdg.configFile."kxkbrc" = {
      force = true;
      text = ''
        [Layout]
        DisplayNames=,
        LayoutList=us,ru
        Options=grp:alt_shift_toggle
        SwitchMode=Global
        Use=true
        VariantList=,
      '';
    };

  # ============================================================
  # VSCodium
  # ============================================================

  programs.vscodium = {
    enable = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        ms-ceintl.vscode-language-pack-ru
        jnoortheen.nix-ide
        rust-lang.rust-analyzer
        golang.go
        llvm-vs-code-extensions.vscode-clangd
        redhat.java
        redhat.vscode-yaml
        mads-hartmann.bash-ide-vscode
        tamasfe.even-better-toml
        sumneko.lua
        detachhead.basedpyright
        mkhl.direnv
        vscodevim.vim
      ];

      userSettings = {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings"."nixd"."formatting"."command" = [ "nixfmt" ];

        "clangd.path" = "clangd";
      };
    };
  };

  xdg.configFile."VSCodium/argv.json" = {
    force = true;
    text = ''
      {
        "locale": "ru"
      }
    '';
  };

  # ============================================================
  # Fish shell
  # ============================================================

  programs.fish = {
    enable = true;
  
    interactiveShellInit = ''
      set -g fish_greeting
    '';
  
    functions = {
      fish_prompt = ''
        echo -n '['
        set_color $fish_color_cwd
        echo -n (prompt_pwd)
        set_color normal
        echo -n '] '
  
        if test (id -u) -eq 0
          set_color red
          echo -n '#'
        else
          set_color white
          echo -n '$'
        end
  
        set_color normal
        echo -n ' '
      '';
    };
  };

  # ============================================================
  # OBS Studio
  # ============================================================

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
      obs-vkcapture
    ];
  };

  # ============================================================
  # Vim
  # ============================================================

  programs.vim = {
    enable = true;

    extraConfig = ''
      highlight MatchParen ctermbg=white ctermfg=black guibg=white guifg=black

      set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
    '';
  };

  # ============================================================
  # Alacritty
  # ============================================================

  programs.alacritty = {
    enable = true;

    settings = {
      env.TERM = "xterm-256color";

      window = {
        padding = { x = 0; y = 0; };
        dynamic_padding = false;
        decorations = "full";
      };

      font = {
        size = 12.0;
        normal      = { family = "JetBrainsMono Nerd Font Mono"; style = "Regular"; };
        bold        = { family = "JetBrainsMono Nerd Font Mono"; style = "Bold"; };
        italic      = { family = "JetBrainsMono Nerd Font Mono"; style = "Italic"; };
        bold_italic = { family = "JetBrainsMono Nerd Font Mono"; style = "Bold Italic"; };
      };

      scrolling.history = 3000;
      selection.save_to_clipboard = true;

      cursor = {
        style = { shape = "Block"; blinking = "Never"; }; # меняешь shape = "Beam" это типо полоска курсор и ещё есть Underline
        vi_mode_style = "None";
      };

      bell.duration = 0;

      colors = {
              primary = {
                background = "#000000";
                foreground = "#dddddd";
              };
      
              cursor = {
                text   = "#111111";
                cursor = "#cccccc";
              };
      
              selection = {
                text       = "#000000";
                background = "#fffacd";
              };
      
              normal = {
                black   = "#000000";
                red     = "#cc0403";
                green   = "#19cb00";
                yellow  = "#cecb00";
                blue    = "#0d73cc";
                magenta = "#cb1ed1";
                cyan    = "#0dcdcd";
                white   = "#dddddd";
              };
      
              bright = {
                black   = "#767676";
                red     = "#f2201f";
                green   = "#23fd00";
                yellow  = "#fffd00";
                blue    = "#1a8fff";
                magenta = "#fd28ff";
                cyan    = "#14ffff";
                white   = "#ffffff";
              };
            };

      keyboard.bindings = [
        { key = "F11"; action = "ToggleFullscreen"; }
        { key = "T"; mods = "Control|Shift"; action = "CreateNewWindow"; }
        { key = "Plus";   mods = "Control"; action = "IncreaseFontSize"; }
        { key = "Equals"; mods = "Control"; action = "IncreaseFontSize"; }
        { key = "Minus";  mods = "Control"; action = "DecreaseFontSize"; }
        { key = "Key0";   mods = "Control"; action = "ResetFontSize"; }
      ];
    };
  };

  # ============================================================
  # Micro
  # ============================================================

  xdg.configFile."micro/settings.json" = {
    force = true;

    text = ''
      {
        "colorscheme": "simple",
        "cursortype": "blinking-bar"
      }
    '';
  };

  xdg.configFile."micro/colorschemes/simple.micro".text = ''
    color-link default "white,black"
    color-link comment "cyan,black"
    color-link identifier "white,black"
    color-link statement "yellow,black"
    color-link preproc "magenta,black"
    color-link type "green,black"
    color-link special "white,black"
    color-link constant "red,black"
    color-link current-line-number "white,"
    color-link line-number "gray,"
  '';

  # ============================================================
  # MIME / Default apps
  # ============================================================

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/terminal" = "Alacritty.desktop";

      "inode/directory" = "org.kde.dolphin.desktop";

	  "text/x-nix" = "org.kde.kate.desktop";
      "text/plain" = "org.kde.kate.desktop";
      "application/x-zerosize" = "org.kde.kate.desktop";
      "application/x-bak" = "org.kde.kate.desktop";

      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";

      "video/mp4" = "haruna.desktop";
      "video/x-matroska" = "haruna.desktop";
      "video/webm" = "haruna.desktop";
      "video/avi" = "haruna.desktop";
      "video/quicktime" = "haruna.desktop";

      "audio/mpeg"    = "elisa.desktop";
      "audio/flac"    = "elisa.desktop";
      "audio/ogg"     = "elisa.desktop";
      "audio/x-wav"   = "elisa.desktop";
      "audio/mp3"     = "elisa.desktop";
      "audio/aac"     = "elisa.desktop";
      "audio/x-aac"   = "elisa.desktop";
      "audio/x-mpegurl" = "elisa.desktop";
      "audio/x-scpls" = "elisa.desktop";

      "image/png" = "org.kde.gwenview.desktop";
      "image/jpeg" = "org.kde.gwenview.desktop";
      "image/gif" = "org.kde.gwenview.desktop";
      "image/webp" = "org.kde.gwenview.desktop";
      "image/svg+xml" = "org.kde.gwenview.desktop";
      "image/avif" = "org.kde.gwenview.desktop";
      "image/jxl" = "org.kde.gwenview.desktop";

      "application/pdf" = "org.kde.okular.desktop";

      "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";
      "application/x-torrent" = "org.qbittorrent.qBittorrent.desktop";
      "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";

      "application/zip" = "org.kde.ark.desktop";
      "application/x-tar" = "org.kde.ark.desktop";
      "application/x-compressed-tar" = "org.kde.ark.desktop";
      "application/x-bzip2-compressed-tar" = "org.kde.ark.desktop";
      "application/x-xz-compressed-tar" = "org.kde.ark.desktop";
      "application/x-7z-compressed" = "org.kde.ark.desktop";
      "application/x-rar" = "org.kde.ark.desktop";
      "application/x-rar-compressed" = "org.kde.ark.desktop";
      "application/x-zstd-compressed-tar" = "org.kde.ark.desktop";

      "x-scheme-handler/mailto" = "org.kde.kmail2.desktop";
      "message/rfc822" = "org.kde.kmail2.desktop";
    };
  };

  # ============================================================
  # LibreWolf
  # ============================================================
  
  programs.librewolf = {
    enable = true;
    configPath = ".librewolf";

    profiles.naizel = {
      bookmarks = {
        force = true;
        settings = [
          {
            name = "Video Speed";
            toolbar = true;
            bookmarks = [
              { name = "1x"; url = "javascript:void(document.querySelector('video').playbackRate=1);"; }
              { name = "2x"; url = "javascript:void(document.querySelector('video').playbackRate=2);"; }
              { name = "3x"; url = "javascript:void(document.querySelector('video').playbackRate=3);"; }
              { name = "4x"; url = "javascript:void(document.querySelector('video').playbackRate=4);"; }
              { name = "5x"; url = "javascript:void(document.querySelector('video').playbackRate=5);"; }
              { name = "6x"; url = "javascript:void(document.querySelector('video').playbackRate=6);"; }
            ];
          }

          {
            name = "NixOS";
            toolbar = true;
            bookmarks = [
              { name = "NixOS Wiki";           url = "https://nixos.wiki/"; }
              { name = "NixOS Search";         url = "https://search.nixos.org/packages"; }
              { name = "Home Manager Options"; url = "https://home-manager-options.extranix.com/"; }
              { name = "NixOS Manual";         url = "https://nixos.org/manual/nixos/stable/"; }
              { name = "Home Manager Manual";  url = "https://nix-community.github.io/home-manager/"; }
              { name = "MyNixOS";              url = "https://mynixos.com/"; }
              { name = "Noogle";               url = "https://noogle.dev/"; }
            ];
          }

          {
            name = "Gaming";
            toolbar = true;
            bookmarks = [
              { name = "ProtonDB";             url = "https://www.protondb.com/"; }
              { name = "SteamDB";              url = "https://steamdb.info/"; }
              { name = "PCGamingWiki";         url = "https://www.pcgamingwiki.com/"; }
              { name = "GamingOnLinux";        url = "https://www.gamingonlinux.com/"; }
              { name = "Lutris";               url = "https://lutris.net/"; }
              { name = "Heroic";               url = "https://heroicgameslauncher.com/"; }
              { name = "Flathub";              url = "https://flathub.org/"; }
              { name = "OpenGameArt";          url = "https://opengameart.org/"; }
              { name = "AreWeAntiCheatYet";    url = "https://areweanticheatyet.com/"; }
              { name = "Modrinth";             url = "https://modrinth.com/"; }
              { name = "NewGrounds";           url = "https://www.newgrounds.com/"; }
            ];
          }

          {
           name = "PoE1";
           toolbar = true;
           bookmarks = [
             { name = "Youtube-Fubgan-Winter-Orb-2.29-Build";              url = "https://www.youtube.com/watch?v=W0AnGpWnSFM"; }
             { name = "Leveling-Winter-Orb-2.29";                          url = "https://pobb.in/J6Pf3nkrUY0Z"; }
             { name = "Endgame-Winter-Orb-2.29";                           url = "https://pobb.in/7K2DlBxbwoeZ"; }
             { name = "MobalysticWrittenGuide-Winter-Orb-2.29";            url = "https://mobalytics.gg/poe/builds/fubgun-winter-orb-elementalist"; }
             { name = "Youtube-BetterGuide-ronarray-Winter-Orb-2.29";      url = "https://youtu.be/yn1MzoinnUw"; }
             { name = "POB-Guide-Winter-Orb-2.29";                         url = "https://mobalytics.gg/poe/builds/winter-orb-occultist-witch-build-league-starter-to-endgame"; }
           ];
         }

         {
          name = "Music";
          toolbar = true;
          bookmarks = [
            { name = "Khinsider";        url = "https://downloads.khinsider.com/"; }
            { name = "Monochrome";       url = "https://monochrome.tf/"; }
            { name = "Lucida";           url = "https://lucida.to/"; }
            { name = "Cobalt";           url = "https://cobalt.tools/"; }
            { name = "Arcod";            url = "https://arcod.xyz/"; }
          ];
         }

         {
          name = "GithubProjects";
          toolbar = true;
          bookmarks = [
            { name = "GuideForEverething";            url = "https://github.com/fmhy/FMHY/wiki"; }
          ];
         }

         {
          name = "LinuxDistros";
          toolbar = true;
          bookmarks = [
            { name = "GentooLinux";       url = "https://www.gentoo.org/"; }
            { name = "VoidLinux";         url = "https://voidlinux.org/"; }
            { name = "ArchLinux";         url = "https://archlinux.org/"; }
            { name = "FreeBSD";           url = "https://www.freebsd.org/"; }
            { name = "NixOS";             url = "https://nixos.org/"; }
          ];
         }

          {
            name = "Other";
            toolbar = true;
            bookmarks = [
              { name = "Internet-Archive";  url = "https://archive.org/"; }
              { name = "Aero-Wallpapers";   url = "https://frutigeraeroarchive.org/"; }
              { name = "Wallhaven";         url = "https://wallhaven.cc/"; }
              { name = "Sacenao";           url = "https://saucenao.com/"; }
              { name = "WallpaperCave";     url = "https://wallpapercave.com/"; }
              { name = "DOTABUFF";          url = "https://ru.dotabuff.com/"; }
              { name = "LOR";               url = "https://www.linux.org.ru/"; }
              { name = "Pingvinus";         url = "https://pingvinus.ru/"; }
              { name = "NeoLurk";           url = "https://neolurk.org/"; }
              { name = "2chan";             url = "https://2ch.org/"; }
              { name = "4chan";             url = "https://4chan.org/"; }
              { name = "8chan";             url = "https://8chan.moe/"; }
              { name = "8kun";              url = "https://8kun.top/"; }
              { name = "64chan";            url = "https://64chan.net/"; }
              { name = "UrbanDictionary";   url = "https://www.urbandictionary.com/"; }
              { name = "Spacehey";          url = "https://spacehey.com/"; }
              { name = "Rutracker";         url = "https://rutracker.org/"; }
              { name = "FitGirl";           url = "https://fitgirl-repacks.site/"; }
              { name = "Reddit";            url = "https://www.reddit.com/"; }
              { name = "JoyReactor";        url = "https://joyreactor.cc/"; }
              { name = "Squidwtf";          url = "https://squid.wtf/"; }
              { name = "DanBooru";          url = "https://danbooru.donmai.us/"; }
              { name = "TerminalTrove";     url = "https://terminaltrove.com/"; }
            ];
          }
        ];
      };

      settings = {
              "browser.uidensity"                                = 1;
              "full-screen-api.warning.timeout"                  = 0;
              "browser.translations.automaticallyPopup"          = false;
      };
    };
  };
}
