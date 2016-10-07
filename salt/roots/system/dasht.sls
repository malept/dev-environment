{%- set dasht_version = salt['pillar.get']('dasht:version') %}
{%- if dasht_version %}
dasht:
  archive.extracted:
    - name: /opt/dasht/
    - source: https://github.com/sunaku/dasht/archive/v{{ dasht_version }}.tar.gz
    - source_hash: sha256={{ salt['pillar.get']('dasht:sha256sum') }}
{%- if grains['saltversioninfo'] >= [2016, 3, 0] %}
    - source_hash_update: true
{%- endif %}
    - archive_format: tar
    - tar_options: z --strip-components 1
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
{%- endif %}
