{% from 'venv_bin.sls' import venv2, venv3, venv3_with_binary with context %}
{%- set pillar_get = salt['pillar.get'] %}

{%- if pillar_get('neovim:enabled') %}
{%- if grains['os'] == 'Ubuntu' %}
neovim:
  pkg.installed:
    - require:
      - pkgrepo: neovim
{%- if pillar_get('fzy:version') %}
      - pkg: fzy
{%- endif %}
  pkgrepo.managed:
    - ppa: neovim-ppa/unstable
{%- elif pillar_get('debian:repos:personal') %}
neovim:
  pkg.installed:
    - require:
      - pkg: neovim-runtime-deps
      - pkgrepo: debian.personal
{%- endif %}

{%- if pillar_get('python:python2') %}
{{ venv2('neovim', 'salt://system/files/neovim-requirements.txt', True) }}
{%- endif %}
{{ venv3('neovim3', 'salt://system/files/neovim-requirements.txt', True) }}
{%- if salt['pillar.get']('neovim:remote:enabled') %}
{{ venv3_with_binary('neovim-remote', 'nvr', 'salt://system/files/neovim-remote-requirements.txt') }}
{%- endif %}
{%- endif %}
