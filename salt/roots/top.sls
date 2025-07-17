# vim: set ft=sls ts=2 sts=2 sw=2 et :
{%- set pillar_get = salt['pillar.get'] %}
base:
  '*':
{%- if grains['os'] == 'Debian' or pillar_get('debian:enabled') %}
    - debian
{%- endif %}
    - salt.pkgrepo
    - salt.standalone
    - user
    - user.dotfiles
    - user.dotfiles.tmux
    - user.dotfiles.neovim
{%- if pillar_get('nushell:enabled') %}
    - user.dotfiles.nushell
{%- endif %}
    - system
{%- if pillar_get('X11:enabled') or pillar_get('wayland:enabled') %}
    - desktop
{%- elif pillar_get('fonts:enabled') %}
    - desktop.fonts
{%- endif %}
    - databases
{%- if pillar_get('postgres:enabled', false) %}
    - postgres.apt
    - postgres
{%- if pillar_get('postgres:config:managed', true) %}
    - postgres.config
{%- endif %}
{%- if pillar_get('postgres:pgadmin3:enabled') %}
    - postgres.pgadmin3
{%- endif %}
{%- endif %}
{%- if pillar_get('docker:enabled') %}
    - docker
{%- endif %}
{%- if pillar_get('gcloud:enabled') %}
    - gcloud-sdk
{%- endif %}
{%- if pillar_get('dropbox:enabled') %}
    - dropbox
{%- endif %}
{%- if pillar_get('android:enabled') %}
    - android
{%- endif %}
