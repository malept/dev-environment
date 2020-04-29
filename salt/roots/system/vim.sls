{% from 'venv_bin.sls' import venv, venv_with_binary with context %}
{%- set pillar_get = salt['pillar.get'] %}

{%- if pillar_get('vim:enabled', true) %}
vim:
  pkg.installed:
    - pkgs:
{%- if salt['pillar.get']('vim:gtk') %}
      - vim-gtk
{%- else %}
      - vim-nox
{%- endif %}
{%- if salt['pillar.get']('vim:ctags') %}
      - exuberant-ctags
{%- endif %}
      - editorconfig
{%- endif %}

{%- if pillar_get('neovim:enabled') %}
{%- if grains['os'] == 'Ubuntu' %}
neovim:
  pkg.installed:
    - require:
      - pkgrepo: neovim
      - pkg: neovim-runtime-deps
  pkgrepo.managed:
    - ppa: neovim-ppa/unstable
{%- elif pillar_get('debian:repos:personal') %}
neovim:
  pkg.installed:
    - require:
      - pkg: neovim-runtime-deps
      - pkgrepo: debian.personal
{%- endif %}

neovim-runtime-deps:
  pkg.installed:
    - pkgs:
      - editorconfig
{%- if salt['pillar.get']('vim:ctags') %}
      - exuberant-ctags
{%- endif %}
{%- if salt['pillar.get']('fzy:version') %}
    - require:
      - pkg: fzy
{%- endif %}

{{ venv('neovim', 'salt://system/files/neovim-requirements.txt', 'python2', True) }}
{{ venv('neovim3', 'salt://system/files/neovim-requirements.txt', 'python3', True) }}
{%- if salt['pillar.get']('neovim:remote:enabled') %}
{{ venv_with_binary('neovim-remote', 'nvr', 'salt://system/files/neovim-remote-requirements.txt', python='/usr/bin/python3') }}
{%- endif %}
{%- endif %}
