if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start -c secrets)
    export SSH_AUTH_SOCK
fi
