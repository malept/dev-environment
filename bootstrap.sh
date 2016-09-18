#!/bin/bash

MINION_FILE="$1"
LOCAL_PILLAR="$2"

if ! which git > /dev/null; then
    sudo apt install --no-install-recommends --yes git
fi

if ! which curl > /dev/null; then
    sudo apt install --no-install-recommends --yes curl
fi

if ! test -d ~/Code; then
    mkdir ~/Code
fi
cd ~/Code
if ! test -d dev-environment; then
    git clone --recursive https://github.com/malept/dev-environment
fi
cd dev-environment

if ! test -f "$MINION_FILE"; then
    ORIGINAL_MINION_FILE="$MINION_FILE"
    MINION_FILE="$(pwd)/salt/${MINION_FILE}-minion"
    if ! test -f "$MINION_FILE"; then
        echo "Could not find minion file: $ORIGINAL_MINION_FILE" >&2
        exit 1
    fi
fi

if test -n "$LOCAL_PILLAR" -a -f "$LOCAL_PILLAR"; then
    cp "$LOCAL_PILLAR" "salt/pillars/local/init.sls"
else
    touch "salt/pillars/local/init.sls"
fi

# Yes, I know one-liners suck
curl -L https://bootstrap.saltstack.com | sudo sh -s -- stable

sudo cp "$MINION_FILE" /etc/salt/minion
sudo ln -s $(pwd)/salt/roots /srv/salt
sudo ln -s $(pwd)/salt/formulae /srv/salt-formulae
sudo ln -s $(pwd)/salt/pillars /srv/pillar

sudo salt-call --local state.highstate
