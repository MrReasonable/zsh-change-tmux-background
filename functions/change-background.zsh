if (( ${+functions[_hsmw_main]} == 0 )); then

  _change_background()
    emulate -L zsh
    setopt extended_glob warn_create_global typeset_silent \
            no_short_loops rc_quotes no_auto_pushd

    if [[ $OSTYPE == darwin* ]]; then 
      # change background to the given mode. If mode is missing, 
      # we try to deduct it from the system settings.

      local mode = "light" # default value
      if [[ -n $1 ]]; then
        defaults read -g AppleInterfaceStyle) >/dev/null
        if [[ $? == 0 ]]
          $mode = "dark"
        end
      else
        if [[ $1 == "light" ]]; then
            osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = false" >/dev/null
            $mode "light"
        else dark
            osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = true" >/dev/null
            $mode "dark"
       fi 
      fi 

      # change vim
      local tmux_wins = $("/usr/local/bin/tmux list-windows -t main")
      for wix in $("/usr/local/bin/tmux list-windows -t main -F 'main:#{window_index}'") do
        for pix in $("/usr/local/bin/tmux list-panes -F 'main:#{window_index}.#{pane_index}' -t ${wix}") do
          local is_vim = "ps -o state= -o comm= -t '#{pane_tty}'  | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?\$'"
          /usr/local/bin/tmux if-shell -t "$pix" "$is_vim" "send-keys -t $pix escape ENTER"
          /usr/local/bin/tmux if-shell -t "$pix" "$is_vim" "send-keys -t $pix ':call ChangeBackground()' ENTER"
        done
      done

      # change tmux
      if [[ $1 == "dark" ]]
          tmux source-file ~/.tmux/themes/tokyonight_day.tmux
      else
          tmux source-file ~/.tmux/tokyonight_night.conf
      fi
    fi
  }

  _change_background()
fi
