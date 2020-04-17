{%- set pillar_get = salt['pillar.get'] %}
{%- set helm_version = pillar_get('docker:k8s:helm:version') %}
{%- if helm_version %}
{%- set helm_tarball = 'helm-v{}-{}-{}.tar.gz'.format(helm_version, grains['kernel'].lower(), grains['osarch']) %}
helm:
  archive.extracted:
    - name: /usr/local/bin/
    - source: https://get.helm.sh/{{ helm_tarball }}
    - source_hash: https://get.helm.sh/{{ helm_tarball }}.sha256
    - source_hash_update: true
    - enforce_toplevel: false
    - options: --wildcards *-*/helm --strip-components=1
    - if_missing: /usr/local/bin/helm
    - require:
      - file: /usr/local/bin
{%- endif %}

{%- set k3d_version = pillar_get('docker:k8s:k3d:version') %}
{%- if k3d_version %}
k3d:
  file.managed:
    - name: /usr/local/bin/k3d
    - source: https://github.com/rancher/k3d/releases/download/v{{ k3d_version }}/k3d-{{ grains['kernel'].lower() }}-{{ grains['osarch'] }}
    - mode: 0755
    - skip_verify: True
    - require:
      - file: /usr/local/bin
{%- endif %}

kubectx:
  pkg.installed

{%- set kubeval_version = pillar_get('docker:k8s:kubeval:version') %}
{%- if kubeval_version %}
kubeval:
  archive.extracted:
    - name: /usr/local/bin/
    - source: https://github.com/instrumenta/kubeval/releases/download/{{ kubeval_version }}/kubeval-{{ grains['kernel'].lower() }}-{{ grains['osarch'] }}.tar.gz
    - source_hash: https://github.com/instrumenta/kubeval/releases/download/{{ kubeval_version }}/checksums.txt
    - source_hash_update: true
    - enforce_toplevel: false
    - options: --wildcards kubeval
    - if_missing: /usr/local/bin/kubeval
    {# - require: #}
    {#   - file: /usr/local/bin #}
{%- endif %}

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
