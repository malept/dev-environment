{%- set pillar_get = salt['pillar.get'] -%}
{%- if pillar_get('nushell:enabled') %}
nushell:
  pkgrepo.managed:
    - name: 'deb [signed-by=/etc/apt/trusted.gpg.d/nushell-keyring.gpg arch={{ grains['osarch'] | lower }}] https://apt.fury.io/nushell/ /'
    - humanname: Nushell
    - key_url: https://apt.fury.io/nushell/gpg.key
    - aptkey: False
    - require_in:
      - pkg: nushell
  pkg.installed:
    - refresh: True
{%- endif %}
