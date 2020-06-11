{% from 'wsl.jinja' import is_wsl1, is_wsl2 -%}
{%- if salt['pillar.get']('docker:k8s:enabled') %}
include:
  - .k8s
{%- endif %}

{%- if not is_wsl1 %}
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
      - docker-ce-cli
{%- if not is_wsl2 %}
      - docker-ce
      - containerd.io
{%- endif %}
{%- endif %}

ctop:
  pkg.installed
