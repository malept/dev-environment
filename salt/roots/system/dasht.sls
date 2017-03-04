{%- set dasht_version = salt['pillar.get']('dasht:version') %}
{%- if dasht_version %}
dasht:
  archive.extracted:
    - name: /opt/dasht/
    - source: https://github.com/sunaku/dasht/archive/v{{ dasht_version }}.tar.gz
    - source_hash: sha256={{ salt['pillar.get']('dasht:sha256sum') }}
    - archive_format: tar
{%- if grains['saltversioninfo'] >= [2016, 11, 0] %}
    - source_hash_update: true
    - options: -z --strip-components=1
{% else %}
    - tar_options: -z --strip-components=1
{%- endif %}
    - if_missing: /opt/dasht/bin/dasht
    - require:
      - file: dasht
      - pkg: dasht-deps
  file.directory:
    - name: /opt/dasht/

dasht-deps:
  pkg.installed:
    - pkgs:
      - socat
      - sqlite3
      - w3m
{%- endif %}
