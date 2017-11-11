{% set github_version = salt['pillar.get']('github:version') %}
{%- if github_version %}
github-hub:
  archive.extracted:
    - name: /opt/github/
    - source: https://github.com/github/hub/releases/download/v{{ github_version }}/hub-linux-amd64-{{ github_version }}.tgz
    - source_hash: sha256={{ salt['pillar.get']('github:sha256sum') }}
    - archive_format: tar
{%- if grains['saltversioninfo'] >= [2016, 11, 0] %}
    - enforce_toplevel: false
    - source_hash_update: true
    - options: -z --strip-components=1
{% else %}
    - tar_options: -z --strip-components=1
{%- endif %}
{%- endif %}
