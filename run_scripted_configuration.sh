#!/bin/bash

has() {
  command -v "$1" &>/dev/null
}

has jq || exit

chezDir="$HOME/.config/chezmoi"
chezCfg="$chezDir/chezmoi.json"
chezUpd="${chezCfg}.upd"

[[ ! -d "$chezDir" ]] && mkdir -p "$chezDir"
[[ ! -f "$chezCfg" ]] && echo -n '{}' >"$chezCfg"

set_prop() {
  cat "$chezCfg" | jq --arg part "$1" --arg prop "$2" --arg val "$3" '.data[$part][$prop] = $val' >"$chezUpd"
  mv "$chezUpd" "$chezCfg"
}

warn() {
  echo "$1" 1>&2;
}

if [[ $(chezmoi data | jq -r '.chezmoi.os') == 'linux' ]]; then
  if has xdpyinfo && xdpyinfo &>/dev/null; then
    set_prop 'screen' 'width' "$(xdpyinfo | grep dimensions | awk '{ print $2; }' | awk 'BEGIN {FS="x";} { print $1; }')"
    set_prop 'screen' 'height' "$(xdpyinfo | grep dimensions | awk '{ print $2; }' | awk 'BEGIN {FS="x";} { print $2; }')"
  else
    warn 'missing xdpyinfo or not in x session, cannot set screen width and height'
  fi

  set_prop 'hw' 'gfxdriver' "$(lspci -k | grep -A 2 -E '(VGA|3D)' | grep driver | awk '{ print $5 }')"

  if has getent && has ip; then
    host_ip=$(getent ahosts 'google.com' | awk '{ print $1; exit }') # get first ip in case of multiple
    network_device="$(ip route get "$host_ip" | grep -Po '(?<=(dev ))(\S+)')"
    if [[ -d "/sys/class/net/$network_device/wireless" ]]; then
      set_prop 'network' 'wireless' "$network_device"
    else
      set_prop 'network' 'wired' "$network_device"
    fi
  else
    warn 'missing getent or ip, cannot detect active network interface'
  fi
fi
