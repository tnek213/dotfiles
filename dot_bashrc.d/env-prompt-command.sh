#
# A funny and informative terminal title which:
#   1. Displays a quote when opening a terminal as well as setting it as terminal title
#   2. Shows the current working directory
#   3. Shows the last executed command with a notice if it failed
#
# to make it fun it needs: (but they are optional)
#   fortune
#   cowsay

command -v fortune &>/dev/null || fortune() { true; }
command -v cowsay &>/dev/null || cowsay() { true; }

_set_terminal_title() {
    echo -en "\033]0;${@}\a"
}

_display_command_in_title=false

_update_terminal_title() {
    local exit="$?"

    _second_last_command="$_last_command"

    _last_command="$(history 1 | "sed" -E "s# *[0-9]+ +##")"

    if [[ $_second_last_command != "" && $_second_last_command != $_last_command ]]; then
        _display_command_in_title=true
    fi

    local title

    if [[ $_display_command_in_title == true ]]; then
        title+="$_last_command $([[ exit -gt 0 ]] && echo " (exit code $exit)")"
    else
        if [[ -z $_fortune ]]; then
            _fortune="$(fortune -n 150 -s all)"

            cowsay "$_fortune"
        fi

        title+="$(echo "$_fortune" | tr $'\n' ' ' | sed -E 's/ +/ /g')"
    fi

    local workingDirectory="$("pwd" | "sed" "s#$HOME/##")"

    _set_terminal_title "$workingDirectory" "  ⇢  " "$title"
}

PROMPT_COMMAND='_update_terminal_title'
