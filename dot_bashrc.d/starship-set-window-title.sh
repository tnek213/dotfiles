_starship_set_win_title() {
  echo -ne "\033]0;${PWD/$HOME/\~} \007"
}

starship_precmd_user_func="_starship_set_win_title"
