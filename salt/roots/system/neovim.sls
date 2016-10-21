{% from 'venv_bin.sls' import venv, venv_with_binary with context %}

{%- if salt['pillar.get']('neovim:enabled') %}
{%- if salt['pillar.get']('debian:repos:personal') %}
neovim:
  pkg.installed:
    - require:
      - pkg: neovim-runtime-deps
      - pkgrepo: debian.personal
{%- elif grains['os'] == 'Ubuntu' %}
neovim:
  pkg.installed:
    - require:
      - pkgrepo: neovim
      - pkg: neovim-runtime-deps
  pkgrepo.managed:
    - ppa: neovim-ppa/unstable
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
