{% from 'wsl.jinja' import is_wsl1, is_wsl2 -%}
{%- if not is_wsl1 %}
docker:
  pkgrepo.managed:
    - name: 'deb [signed-by=/etc/apt/trusted.gpg.d/docker-keyring.gpg arch={{ salt['grains.get']('osarch') | lower }}] https://download.docker.com/linux/debian {{ grains['oscodename'] }} stable'
    - humanname: Docker
    - file: /etc/apt/sources.list.d/docker.list
    - key_url: https://download.docker.com/linux/debian/gpg
    - aptkey: False
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
