include:
  - .browsers
  - .fonts
  - .sound

{%- set pillar_get = salt['pillar.get'] -%}
{%- set xfce_enabled = pillar_get('X11:Xfce:enabled') -%}
{%- if xfce_enabled -%}
xfce:
  pkg.installed:
    - pkgs:
      - python-dbus
      - xfce4
      - xfce4-indicator-plugin
      - xfce4-screenshooter-plugin
      - xfce4-terminal

lightdm:
  pkg.installed
{%- endif %}

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
{%- if xfce_enabled -%}
      - synapse
{%- endif %}
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
    - name: 'deb https://apt.fury.io/wez/ * *'
    - humanname: Wezterm
    - file: /etc/apt/sources.list.d/wezterm.list
    - key_url: https://apt.fury.io/wez/gpg.key
    - require_in:
        pkg: wezterm
  pkg.installed

# Theme-related
themes:
  pkg.installed:
    - pkgs:
      - gnome-wise-icon-theme
{%- if xfce_enabled -%}
      - shiki-colors-xfwm-theme
{%- else %}
      - gnome-tweaks
{%- endif %}
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

{%- if xfce_enabled -%}
/etc/lightdm/lightdm-gtk-greeter.conf:
  file.managed:
    - source: salt://desktop/files/lightdm-gtk-greeter.conf.jinja
    - template: jinja
    - require:
      - pkg: lightdm
      - file: {{ wallpaper['filename'] }}
{%- endif %}
