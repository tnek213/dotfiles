#
# editor override which:
#   1. only intercepts editor calls with exactly one argument (the filename)
#   2. only intercepts files managed by chezmoi, changing them to chezmoi
#      chezmoi edit with auto apply
#
# The goal is to never forget to use chezmoi edit when editing a file it
# manages, and avoid the resulting hassle.

# include file containing _chezmoi-override-auto-apply()
. $(dirname $(readlink -f $BASH_SOURCE))/chezmoi-override-auto-apply.sh

_edit-configs-chezmoi() {
    local override=false

    if [[ $# -eq 1 && -f $1 ]]; then
        local file="$(readlink -f "$1")"

        local managedFile
        while read managedFile; do
            managedFile="$(readlink -f "$HOME/$managedFile")"

            if [[ $file == $managedFile ]]; then
                override=true
                break
            fi
        done < <(chezmoi managed)
    fi

    if [[ $override == true ]]; then
        _chezmoi-override-auto-apply edit "$file"
    else
        "$EDITOR" "$@"
    fi
}

# alias editors to override
for _overrideEditor in vi vim emacs nano; do
    command -v $_overrideEditor &>/dev/null && alias $_overrideEditor=_edit-configs-chezmoi
done
unset _overrideEditor
