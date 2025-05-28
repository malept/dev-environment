{% from 'venv_bin.sls' import venv2, venv3, venv3_with_binary with context %}
{%- set pillar_get = salt['pillar.get'] %}

{%- if pillar_get('neovim:enabled') %}
{#- Non-Ubuntu or Ubuntu+stable neovim installs are managed by mise #}
{%- if grains['os'] == 'Ubuntu' and pillar_get('neovim:version', 'latest') == 'unstable' %}
neovim:
  pkg.installed:
    - require:
      - pkgrepo: neovim
{%- if pillar_get('fzy:version') %}
      - pkg: fzy
{%- endif %}
  pkgrepo.managed:
    - ppa: neovim-ppa/unstable
{%- endif %}

{%- if pillar_get('python:python2') %}
{{ venv2('neovim', 'salt://system/files/neovim-requirements.txt', True) }}
{%- endif %}
{{ venv3('neovim3', 'salt://system/files/neovim-requirements.txt', True) }}
{%- endif %}
