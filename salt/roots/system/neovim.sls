{%- set pillar_get = salt['pillar.get'] %}

{%- if pillar_get('neovim:enabled') %}
{#- Non-Ubuntu or Ubuntu+stable neovim installs are managed by mise #}
{%- if grains['os'] == 'Ubuntu' and pillar_get('neovim:version', 'latest') == 'unstable' %}
neovim:
  pkg.installed:
    - require:
      - pkgrepo: neovim
  pkgrepo.managed:
    - ppa: neovim-ppa/unstable
{%- endif %}
{%- endif %}
