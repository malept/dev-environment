{%- if salt['pillar.get']('docker:k8s:enabled') %}
include:
  - .k8s
{%- endif %}

{%- if not grains['kernelrelease'].endswith('-Microsoft') %}
docker:
  pkgrepo.managed:
    - name: 'deb [arch=amd64] https://download.docker.com/linux/debian {{ grains['oscodename'] }} stable'
    - humanname: Docker
    - file: /etc/apt/sources.list.d/docker.list
    - key_url: https://download.docker.com/linux/debian/gpg
    - require_in:
      - pkg: docker
  pkg.installed:
    - pkgs:
      - docker-ce
      - docker-ce-cli
      - containerd.io
{%- endif %}

ctop:
  pkg.installed
