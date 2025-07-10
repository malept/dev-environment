{% if salt['pillar.get']('vagrant:enabled') -%}
vagrant:
  pkgrepo.managed:
    - name: 'deb [signed-by=/etc/apt/trusted.gpg.d/hashicorp-archive-keyring.gpg arch={{ grains['osarch'] | lower }}] https://apt.releases.hashicorp.com {{ grains['oscodename'] }} main'
    - file: /etc/apt/sources.list.d/hashicorp.list
    - key_url: https://apt.releases.hashicorp.com/gpg
    - aptkey: False
    - require_in:
      - pkg: vagrant
  pkg.installed:
    - refresh: true
{%- endif %}
