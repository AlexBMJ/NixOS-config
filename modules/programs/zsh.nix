{ pkgs, lib, config, username, ... }:
with lib;
let
  module_name = "zsh";
  cfg = config.configured.programs."${module_name}";
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable zsh Terminal Emulator";
  };

  config = mkIf cfg.enable {
    programs.zsh.enable = true;
    environment.pathsToLink = [ "/share/zsh" ]; # Needed for zsh completion for system packages
    users.defaultUserShell = pkgs.zsh;

    home-manager.users.${username} = {
      programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;

        history = {
          size = 10000;
          path = "/home/${username}/.local/share/zsh/.zsh_history";
        };

        initExtraFirst = ''
          emulate zsh -c "$(direnv export zsh)"

          # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
          # Initialization code that may require console input (password prompts, [y/n]
          # confirmations, etc.) must go above this block; everything else may go below.
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi

          emulate zsh -c "$(direnv hook zsh)"
        '';

        initExtra = ''
          # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        '';

        zplug = {
          enable = true;
          plugins = [
            { name = "romkatv/powerlevel10k"; tags = [ "as:theme" "depth:1" ]; }
          ];
        };
      };
    };
  };
}
