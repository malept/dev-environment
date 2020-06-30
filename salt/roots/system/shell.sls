{%- set shellcheck_version = salt['pillar.get']('shellcheck:version') %}
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

{%- set shfmt_version = salt['pillar.get']('shfmt:version') %}
{%- if shfmt_version %}
/usr/local/bin/shfmt:
  file.managed:
    - source: https://github.com/mvdan/sh/releases/download/v{{ shfmt_version }}/shfmt_v{{ shfmt_version }}_{{ grains['kernel'].lower() }}_{{ grains['osarch'] }}
    - source_hash: {{ salt['pillar.get']('shfmt:source_hash') }}
    - mode: 0755
{%- endif %}
