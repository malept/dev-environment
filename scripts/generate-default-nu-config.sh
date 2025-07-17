#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
ROOT_DIR="$DIR/.."

nu --commands "config env --default" >"$ROOT_DIR"/salt/roots/user/dotfiles/files/nushell/env/00-default.nu

nu --commands "config nu --default" >"$ROOT_DIR"/salt/roots/user/dotfiles/files/nushell/config/00-default.nu
