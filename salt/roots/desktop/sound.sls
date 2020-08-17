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
    - dir_mode: 755
{%- endif %}

{%- set noisetorch_version = pillar_get('noisetorch:version') %}
{%- if noisetorch_version %}
noisetorch:
  archive.extracted:
    - name: /opt/noisetorch
    - source: https://github.com/lawl/NoiseTorch/releases/download/{{ noisetorch_version }}-beta/NoiseTorch_x64.tgz
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - enforce_toplevel: false
    - skip_verify: true
    - options: --strip-components 2
    - require:
      - file: noisetorch
  file.directory:
    - name: /opt/noisetorch
    - dir_mode: 755

noisetorch.desktop:
  file.symlink:
    - name: /home/{{ grains['username'] }}/.local/share/applications/noisetorch.desktop
    - target: /opt/noisetorch/share/applications/noisetorch.desktop
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - makedirs: true
    - require:
      - archive: noisetorch

noisetorch.png:
  file.symlink:
    - name: /home/{{ grains['username'] }}/.local/share/icons/hicolor/256x256/apps/noisetorch.png
    - target: /opt/noisetorch/share/icons/hicolor/256x256/apps/noisetorch.png
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - makedirs: true
    - require:
      - archive: noisetorch
{%- endif %}
