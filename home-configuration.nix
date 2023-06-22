# Home folder configuration for user "dylan"

{ config, lib, pkgs, modulesPath, ... }:

{
    imports = [ <home-manager/nixos> ];
    home-manager.useGlobalPkgs = true;
    home-manager.users.dylan = { pkgs, ... }: {
        home.stateVersion = "23.05";
        home.packages = [ ];
        programs.alacritty = {
            enable = true;
            settings = {
                env = {
                    TERM = "alacritty";
                    LANG = "en_US.UTF-8";
                    LC_CTYPE = "en_US.UTF-8";
                };
                font = {
                    normal = {
                        family = "Ubuntu Mono";
                        style = "Regular";
                    };
                    size = 12;
                };
                colors = { # Based on Dracula, but with a better blue
                    primary = {
                        background = "#282a37";
                        foreground = "#f8f8f2";
                        bright_foreground = "#ffffff";
                    };
                    cursor = {
                        text = "CellBackground";
                        cursor = "CellForeground";
                    };
                    vi_mode_cursor = {
                        text = "CellBackground";
                        cursor = "CellForeground";
                    };
                    search = {
                        matches = {
                            foreground = "#44475a";
                            background = "#50fa7b";
                        };
                        focused_match = {
                            foreground = "#44475a";
                            background = "#ffb86c";
                        };
                        footer_bar = {
                            foreground = "#f8f8f2";
                            background = "#282a36";
                        };
                    };
                    hints = {
                        start = {
                            foreground = "#282a36";
                            background = "#f1fa8c";
                        };
                        end = {
                            foreground = "#f1fa8c";
                            background = "#282a36";
                        };
                    };
                    selection = {
                        text = "CellForeground";
                        background = "#44475a";
                    };
                    normal = {
                        black = "#21222c";
                        red = "#ff5555";
                        green = "#50fa7b";
                        yellow = "#f1fa8c";
                        blue = "#0066cf";
                        magenta = "#ff79c6";
                        cyan = "#8be9fd";
                        white = "#f8f8f2";
                    };
                    bright = {
                        black = "#6272a4";
                        red = "#ff6e6e";
                        green = "#69ff94";
                        yellow = "#ffffa4";
                        blue = "#1177ff";
                        magenta = "#ff92df";
                        cyan = "#a4ffff";
                        white = "#ffffff";
                    };
                };
            };
        };
        services.dunst = {
            enable = true;
            settings = {
                global = {
                    frame_width = 5;
                    icon_theme = "Papirus-Dark";
                };
                urgency_low = {
                    background = "#282a36";
                    foreground = "#f8f8f2";
                };
                urgency_normal = {
                    background = "#282a36";
                    foreground = "#f8f8f2";
                };
            };
        };
        gtk = {
            enable = true;
            theme.name = "Arc-Dark";
            iconTheme.name = "Papirus-Dark";
            cursorTheme.name = "breeze_cursors";
        };
        xresources.properties = {
            "Xft.antialias" = true;
            "Xft.hinting" = true;
            "Xft.rgba" = "rgba";
            "Xft.hintstyle" = "hintslight";
            "Xft.dpi" = 96;
            "Xcursor.size" = 24;
            "Xcursor.theme" = "breeze_cursors";
        };
        programs.zsh = {
            enable = true;
            enableAutosuggestions = true;
            enableCompletion = true;
            autocd = true;
            shellAliases = {
                rm = "trash";
                "\$(date +%Y)" = "echo \"YEAR OF THE LINUX DESKTOP!\"";
            };
            initExtra = "
                # Theme - Based on oh-my-zsh 'gentoo' theme
                autoload -Uz colors && colors
                autoload -Uz vcs_info
                zstyle ':vcs_info:*' check-for-changes true
                zstyle ':vcs_info:*' unstagedstr '%F{red}*'   # display this when there are unstaged changes
                zstyle ':vcs_info:*' stagedstr '%F{yellow}+'  # display this when there are staged changes
                zstyle ':vcs_info:*' actionformats '%F{5}(%F{2}%b%F{3}|%F{1}%a%c%u%m%F{5})%f '
                zstyle ':vcs_info:*' formats '%F{5}(%F{2}%b%c%u%m%F{5})%f '
                zstyle ':vcs_info:svn:*' branchformat '%b'
                zstyle ':vcs_info:svn:*' actionformats '%F{5}(%F{2}%b%F{1}:%{3}%i%F{3}|%F{1}%a%c%u%m%F{5})%f '
                zstyle ':vcs_info:svn:*' formats '%F{5}(%F{2}%b%F{1}:%F{3}%i%c%u%m%F{5})%f '
                zstyle ':vcs_info:*' enable git cvs svn
                zstyle ':vcs_info:git*+set-message:*' hooks untracked-git
                +vi-untracked-git() {
                  if command git status --porcelain 2>/dev/null | command grep -q '??'; then
                    hook_com[misc]='%F{red}?'
                  else
                    hook_com[misc]=''
                  fi
                }
                gentoo_precmd() {
                  vcs_info
                }
                setopt prompt_subst
                autoload -U add-zsh-hook
                add-zsh-hook precmd gentoo_precmd
                PROMPT='%(!.%B%F{red}.%B%F{green}%n@)%m %F{blue}%(!.%1~.%~) \${vcs_info_msg_0_}%F{blue}%(!.#.$)%k%b%f '

                # Extra config options
                setopt extendedglob
                bindkey \"^[[3~\" delete-char
                zstyle ':completion:*' menu select

                # Hot fix as the history substring search causes issues with \" vs '
                source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
                source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
                bindkey \"\$terminfo[kcuu1]\" history-substring-search-up
                bindkey \"\$terminfo[kcud1]\" history-substring-search-down
            ";
            localVariables = {
                TERM = "xterm-256color";
                PATH = "$HOME/.local/bin;$HOME/.cargo/bin:$PATH";
                EDITOR = "nvim";
            };
        };
    };
}

