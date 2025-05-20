# vim: set ft=sls ts=2 sts=2 sw=2 et :
base:
  '*':
{%- if grains['os'] == 'Debian' or salt['pillar.get']('debian:enabled') %}
    - debian
{%- endif %}
{%- if not (grains['os'] == 'Debian' and grains['oscodename'] == 'stretch') %}
    - salt.pkgrepo
{%- endif %}
    - salt.standalone
    - user
    - user.dotfiles
    - user.dotfiles.tmux
    - user.dotfiles.neovim
    - system
{%- if salt['pillar.get']('X11:enabled') or salt['pillar.get']('wayland:enabled') %}
    - desktop
{%- elif salt['pillar.get']('fonts:enabled') %}
    - desktop.fonts
{%- endif %}
    - databases
{%- if salt['pillar.get']('postgres:enabled', false) %}
    - postgres.apt
    - postgres
{%- if salt['pillar.get']('postgres:config:managed', true) %}
    - postgres.config
{%- endif %}
{%- if salt['pillar.get']('postgres:pgadmin3:enabled') %}
    - postgres.pgadmin3
{%- endif %}
{%- endif %}
{%- if salt['pillar.get']('docker:enabled') %}
    - docker
{%- endif %}
{%- if salt['pillar.get']('gcloud:enabled') %}
    - gcloud-sdk
{%- endif %}
{%- if salt['pillar.get']('dropbox:enabled') %}
    - dropbox
{%- endif %}
    - phantomjs
{%- if salt['pillar.get']('webserver:enabled') %}
    - webserver
{%- endif %}
{%- if salt['pillar.get']('android:enabled') %}
    - android
{%- endif %}
