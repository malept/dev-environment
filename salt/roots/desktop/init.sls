include:
  - .browsers
  - .fonts
  - .sound

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
{%- if pillar_get('pidgin:enabled') %}
      - pidgin
{%- endif %}

wezterm:
  pkgrepo.managed:
    - name: 'deb [signed-by=/etc/apt/trusted.gpg.d/wezterm-keyring.gpg arch={{ grains['osarch'] | lower }}] https://apt.fury.io/wez/ * *'
    - humanname: Wezterm
    - file: /etc/apt/sources.list.d/wezterm.list
    - key_url: https://apt.fury.io/wez/gpg.key
    - signedby: /etc/apt/keyrings/wezterm-keyring.gpg
    - aptkey: False
    - require_in:
      - pkg: wezterm
  pkg.installed:
    - refresh: True

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
