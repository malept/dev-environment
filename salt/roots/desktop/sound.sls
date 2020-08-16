{%- set pillar_get = salt['pillar.get'] -%}
{%- set nsfv_version = pillar_get('nsfv:version') %}
{%- if nsfv_version %}
noise-suppression-for-voice:
  archive.extracted:
    - name: /opt/nsfv
    - source: https://github.com/werman/noise-suppression-for-voice/releases/download/v{{ pillar_get('nsfv:version') }}/linux_rnnoise_bin_x64.tar.gz
    - user: root
    - group: audio
    - enforce_toplevel: false
    - skip_verify: true
    - options: --strip-components 1
    - require:
      - file: noise-suppression-for-voice
  file.directory:
    - name: /opt/nsfv
    - file_mode: 644
    - dir_mode: 755
{%- endif %}
