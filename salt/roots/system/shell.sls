{% from 'rust.sls' import cargo_install with context %}
{%- set pillar_get = salt['pillar.get'] -%}

{%- set shellcheck_version = pillar_get('shellcheck:version') %}
{%- if shellcheck_version %}
shellcheck:
  archive.extracted:
    - name: /usr/local/bin/
    - source: https://github.com/koalaman/shellcheck/releases/download/v{{ shellcheck_version }}/shellcheck-v{{ shellcheck_version }}.{{ grains['kernel'].lower() }}.{{ grains['cpuarch'] }}.tar.xz
    - enforce_toplevel: False
    - skip_verify: True
    - options: --wildcards */shellcheck --strip-components 1
    - if_missing: /usr/local/bin/shellcheck
    - require:
      - file: /usr/local/bin
{%- endif %}

{%- set shfmt_version = pillar_get('shfmt:version') %}
{%- if shfmt_version %}
/usr/local/bin/shfmt:
  file.managed:
    - source: https://github.com/mvdan/sh/releases/download/v{{ shfmt_version }}/shfmt_v{{ shfmt_version }}_{{ grains['kernel'].lower() }}_{{ grains['osarch'] }}
    - source_hash: {{ pillar_get('shfmt:source_hash') }}
    - mode: 0755
{%- endif %}

{%- if pillar_get('rust:enabled') %}
rust-openssl-dependencies:
  pkg.installed:
    - pkgs:
      - libssl-dev
      - pkg-config

{%- if pillar_get('nushell:enabled') %}
nushell-stable-dependencies:
  pkg.installed:
    - pkgs:
      - libx11-dev
      - libxcb-composite0-dev

{{ cargo_install('nu', features='stable', requires=[['pkg', 'rust-openssl-dependencies'], ['pkg', 'nushell-stable-dependencies']]) }}
# TODO: figure out how to automatically add to /etc/shells
{%- endif %}

{%- if pillar_get('starship:enabled') %}
{{ cargo_install('starship', requires=[['pkg', 'rust-openssl-dependencies'], ['pkg', 'starship-dependencies']]) }}

starship-dependencies:
  pkg.installed:
    - pkgs:
        - cmake
{%- endif %}
{%- endif %}
