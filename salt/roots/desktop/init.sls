include:
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

# Browsers

browsers:
  pkg.installed:
    - pkgs:
      - firefox
{%- if pillar_get('firefox:mp3_support') %}
      - gstreamer1.0-plugins-ugly
{%- endif %}
{%- if grains['os'] == 'Ubuntu' %}
      - chromium-browser
{%- else %}
      - chromium
{%- endif %}
{%- if pillar_get('profile-sync-daemon:enabled') %}
      - profile-sync-daemon
{%- endif %}
{%- if grains['oscodename'] in ['jessie', 'stretch'] %}
    - fromrepo: unstable
{%- endif %}

# Theme-related
themes:
  pkg.installed:
    - pkgs:
      - gnome-wise-icon-theme
{%- if xfce_enabled -%}
      - shiki-colors-xfwm-theme
{%- else %}
      - gnome-tweak-tool
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
