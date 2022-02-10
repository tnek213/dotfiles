#!/bin/bash

if [[ -d ~/Dropbox ]]; then
  source ~/Dropbox/todotxt/config

  if command -v todo &>/dev/null; then
    alias t=todo
  elif command -v todo.sh &>/dev/null; then
    alias t=todo.sh
  fi
fi
