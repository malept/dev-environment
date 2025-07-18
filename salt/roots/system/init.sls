{% from 'wsl.jinja' import is_wsl -%}

include:
  - .git
  - .mise
  - .neovim
  - .shell
  - .vagrant

{%- if not is_wsl and grains['virtual'] != 'container' %}
America/Los_Angeles:
  timezone.system:
    - utc: True
{%- endif %}

tops:
  pkg.installed:
    - pkgs:
      - htop
      - iftop

{%- if salt['pillar.get']('profile-sync-daemon:enabled') and salt['pillar.get']('profile-sync-daemon:overlayfs') %}
/etc/sudoers.d/profile-sync-daemon:
  file.managed:
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - source: salt://system/files/profile-sync-daemon.sudoers
    - check_cmd: visudo -c -f
    - require:
      - pkg: browsers
{%- endif %}

sshfs:
  pkg.installed

unzip:
  pkg.installed

/usr/local/bin:
  file.directory

{%- if salt['pillar.get']('imagemagick:enabled', false) %}
imagemagick:
  pkg.installed
{%- endif %}

{%- if is_wsl and grains['os'] == 'Debian' %}
wslu:
  pkg.installed:
    - require:
      - pkgrepo: wslu
  pkgrepo.managed:
    - name: "deb https://pkg.wslutiliti.es/debian {{ grains['oscodename'] }} main"
    - file: /etc/apt/sources.list.d/wslu.list
    - key_url: https://pkg.wslutiliti.es/public.key

/usr/local/bin/xdg-open:
  file.symlink:
    - target: /usr/bin/wslview
    - require:
      - file: /usr/local/bin
{%- endif %}

build-essential:
  pkg.installed
