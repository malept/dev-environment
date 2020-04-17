{%- set pillar_get = salt['pillar.get'] %}
{%- set helm_version = pillar_get('dockerhelm:version') %}
{%- if helm_version %}
{%- set helm_tarball = 'helm-v{}-{}-{}.tar.gz'.format(helm_version, grains['kernel'].lower(), grains['osarch']) %}
helm:
  archive.extracted:
    - name: /usr/local/bin/
    - source: https://get.helm.sh/{{ helm_tarball }}
    - source_hash: https://get.helm.sh/{{ helm_tarball }}.sha256
    - archive_format: tar
    - source_hash_update: true
    - options: z
    - require:
      - file: /usr/local/bin
{%- endif %}

{%- set k3d_version = pillar_get('docker:k8s:k3d:version') %}
{%- if k3d_version %}
k3d:
  file.managed:
    - name: /usr/local/bin/k3d
    - source:
      - https://github.com/rancher/k3d/releases/download/v{{ k3d_version }}/k3d-{{ grains['kernel'].lower() }}-{{ grains['osarch'] }}
    - mode: 0755
    - skip_verify: True
    - require:
      - file: /usr/local/bin
{%- endif %}

kubectx:
  pkg.installed

{%- if pillar_get('docker:k8s:telepresence:enabled') %}
telepresence:
  pkgrepo.managed:
    - name: "deb https://packagecloud.io/datawireio/telepresence/{{ grains['os'].lower() }}/ {{ grains['oscodename'] }} main"
    - file: /etc/apt/sources.list.d/datawireio_telepresence.list
    - key_url: https://packagecloud.io/datawireio/telepresence/gpgkey
  pkg.installed:
    - require:
      - pkgrepo: telepresence
{%- endif %}
