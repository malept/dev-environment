include:
  - .browsers
  - .fonts
  - .sound
  - .terminal

{%- set pillar_get = salt['pillar.get'] -%}

{%- if grains['virtual'] == 'VirtualBox' %}
virtualbox-guest-x11:
  pkg.installed{%- if grains['oscodename'] == 'wheezy' %}:
    - fromrepo: wheezy-backports
  {%- elif grains['oscodename'] == 'stretch' %}:
    - fromrepo: unstable
  {%- endif %}
{%- elif grains['virtual'] == 'VMware' %}
open-vm-tools-desktop:
  pkg.installed{%- if grains['oscodename'] in ['wheezy', 'jessie'] %}:
    - fromrepo: {{ grains['oscodename'] }}-backports
  {%- endif %}
{%- endif %}

desktop-apps:
  pkg.installed:
    - pkgs:
      - file-roller
      - gnome-keyring
      - gucharmap
{%- if pillar.get('X11:enabled') %}
      - xsel
{%- endif %}
{%- if pillar.get('wayland:enabled') %}
      - wl-clipboard
{%- endif %}
{%- if pillar_get('libreoffice:enabled') %}
      - libreoffice
{%- endif %}

# Theme-related
themes:
  pkg.installed:
    - pkgs:
      - gnome-wise-icon-theme
      - gnome-tweaks
      - shiki-wise-theme

{% from 'wallpaper.sls' import wallpaper -%}
{{ wallpaper['filename'] }}:
  file.managed:
    - source: {{ wallpaper['source'] }}
    - source_hash: {{ wallpaper['source_hash'] }}
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - mode: 644
    - makedirs: True
