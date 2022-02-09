_starship_set_win_title() {
  local last_cmd=$(history 1 | head -c 300 )
  echo -ne "\033]0; $last_cmd  ${PWD/$HOME/\~} \007"
}

starship_precmd_user_func="_starship_set_win_title"
