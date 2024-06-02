# Configure zsh with home-manager

{ config, lib, pkgs, modulesPath, ... }:

{
    home-manager.users.dylan.programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
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
            zstyle ':vcs_info:*' unstagedstr '%F{red}*'   # display when unstaged changes
            zstyle ':vcs_info:*' stagedstr '%F{yellow}+'  # display when staged changes
            zstyle ':vcs_info:*' actionformats '%F{5}(%F{2}%b%F{3}|%F{1}%a%c%u%m%F{5})%f '
            zstyle ':vcs_info:*' formats '%F{5}(%F{2}%b%c%u%m%F{5})%f '
            zstyle ':vcs_info:svn:*' branchformat '%b'
            zstyle ':vcs_info:svn:*' actionformats "
                + "'%F{5}(%F{2}%b%F{1}:%{3}%i%F{3}|%F{1}%a%c%u%m%F{5})%f '
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
            PROMPT='%(!.%B%F{red}.%B%F{green}%n@)%m %F{blue}%(!.%1~.%~) "
                + "\${vcs_info_msg_0_}%F{blue}%(!.#.$)%k%b%f '

            # Extra config options
            setopt extendedglob
            bindkey \"^[[3~\" delete-char
            zstyle ':completion:*' menu select
            export PATH=\"$HOME/.cargo/bin:$PATH\"

            # Hot fix as the history substring search causes issues with \" vs '
            source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/"
                + "zsh-syntax-highlighting.zsh
            source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/"
                + "zsh-history-substring-search.zsh
            bindkey \"\$terminfo[kcuu1]\" history-substring-search-up
            bindkey \"\$terminfo[kcud1]\" history-substring-search-down

            function c() {
                echo \"\$1\" | bc
            }

            paleofetch --recache
        ";
        localVariables = {
            TERM = "xterm-256color";
            EDITOR = "nvim";
        };
    };
}
