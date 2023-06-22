# Home folder configuration for user "dylan"

{ config, lib, pkgs, modulesPath, ... }:

{
    imports = [ <home-manager/nixos> ];
    home-manager.useGlobalPkgs = true;
    home-manager.users.dylan = { pkgs, ... }: {
        home.stateVersion = "23.05";
        home.packages = [ ];
        xresources.properties = {
            "Xft.antialias" = true;
            "Xft.hinting" = true;
            "Xft.rgba" = "rgba";
            "Xft.hintstyle" = "hintslight";
            "Xft.dpi" = 96;
            "Xcursor.size" = 24;
            "Xcursor.theme" = "breeze_cursors";
        };
        gtk = {
            enable = true;
            theme.name = "Arc-Dark";
            iconTheme.name = "Papirus-Dark";
            cursorTheme.name = "breeze_cursors";
        };
        programs.zsh = {
            enable = true;
            enableAutosuggestions = true;
            enableCompletion = true;
            enableSyntaxHighlighting = true;
            autocd = true;
            historySubstringSearch = {
                enable = true;
                # Can't use because it uses ' instead of ", so it doesn't eval
                #searchUpKey = "\$terminfo[kcuu1]";
                #searchDownKey = "\$terminfo[kcud1]";
            };
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
            ";
            localVariables = {
                TERM = "xterm-256color";
                PATH = "$HOME/.local/bin;$HOME/.cargo/bin:$PATH";
                EDITOR = "nvim";
            };
        };
    };
}
