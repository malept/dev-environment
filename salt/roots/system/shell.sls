{%- set pillar_get = salt['pillar.get'] -%}
{%- if pillar_get('nushell:enabled') %}
nushell:
  pkgrepo.managed:
    - name: 'deb https://apt.fury.io/nushell/ /'
    - humanname: Nushell
    - key_url: https://apt.fury.io/nushell/gpg.key
    - require_in:
      - pkg: nushell
  pkg.installed
{%- endif %}
