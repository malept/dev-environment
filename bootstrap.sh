#!/usr/bin/env bash

set -eo pipefail

MINION_FILE="$1"
LOCAL_PILLAR="$2"

if ! which git >/dev/null; then
  sudo apt install --no-install-recommends --yes git
fi

if ! which curl >/dev/null; then
  sudo apt install --no-install-recommends --yes curl ca-certificates
fi

if ! test -d ~/Code/@malept; then
  mkdir -p ~/Code/@malept
fi
cd ~/Code/@malept || exit 1
if ! test -d dev-environment; then
  git clone --recursive https://github.com/malept/dev-environment
fi
cd dev-environment || exit 1
devenv_dir="$(pwd)"

if ! test -f "$MINION_FILE"; then
  ORIGINAL_MINION_FILE="$MINION_FILE"
  MINION_FILE="$devenv_dir/salt/minion/$MINION_FILE"
  if ! test -f "$MINION_FILE"; then
    echo "Could not find minion file: $ORIGINAL_MINION_FILE" >&2
    exit 1
  fi
fi

if test -n "$LOCAL_PILLAR" -a -f "$LOCAL_PILLAR"; then
  cp "$LOCAL_PILLAR" "$devenv_dir/salt/pillars/local/init.sls"
else
  touch "$devenv_dir/salt/pillars/local/init.sls"
fi

tmpdir="${TMPDIR:-/tmp}"
bootstrap="$tmpdir/bootstrap-salt.sh"

curl --location --output "$bootstrap" https://github.com/saltstack/salt-bootstrap/releases/download/v2025.02.24/bootstrap-salt.sh
echo 'a0e3a58fc6358a7c6f708ee4910229e72fbdab7161819514b0696146a2edb62d  bootstrap-salt.sh' >"$tmpdir/bootstrap-salt.sha256"
pushd "$tmpdir" || exit 1
shasum --algorithm 256 --check bootstrap-salt.sha256
popd || exit 1
chmod +x "$bootstrap"
if [[ -n $BOOTSTRAP_SALT_DISABLE_SERVICE_CHECK ]]; then
  touch /tmp/disable_salt_checks
fi
# -X: do not start daemons after installation
sudo "$bootstrap" -X stable
rm "$tmpdir"/bootstrap-salt.{sh,sha256}

sudo cp "$MINION_FILE" /etc/salt/minion
sudo ln -s "$(pwd)"/salt/roots /srv/salt
sudo ln -s "$(pwd)"/salt/formulae /srv/salt-formulae
sudo ln -s "$(pwd)"/salt/pillars /srv/pillar

if [[ -z $SKIP_SALT_CALL ]]; then
  sudo salt-call --local state.highstate
fi
