#
# chezmoi wrapper which:
#   1. Always behaves as --apply was given
#   2. And also applies for each save (without exiting the editor)
#
# The goal is to make it a bit easier to handle configuration files which
# benefit from a right modify-test-loop.

_chezmoi-override-auto-apply() {
    if [[ $1 == edit ]]; then
        # wrap in a sub-shell to suppress job control output
        (
            # wrap in a backgrounded sub-process which polls for changes until chezmoi edit exits
            (
                sleep 1 # give chezmoi a second to start 

                while pgrep chezmoi &>/dev/null; do
                    # only sync if there are ONLY modified files in the chezmoi source
                    chezmoi status | grep -q '^ M ' && if ! chezmoi status | grep -qv '^ M '; then
                        chezmoi apply &>/dev/null
                    fi
                    sleep 1
                done
            ) &>/dev/null &
        )

        # call the real chezmoi and not the alias by using quotations
        "chezmoi" "$@"

        "chezmoi" apply
    else
        "chezmoi" "$@"
    fi
}

alias chezmoi=_chezmoi-override-auto-apply
