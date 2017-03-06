{%- if salt['pillar.get']('X11:Xfce:enabled') -%}
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

{%- if grains['node_type'] == 'vagrant' %}
virtualbox-guest-x11:
  pkg.installed{%- if grains['oscodename'] == 'wheezy' %}:
    - fromrepo: wheezy-backports
  {%- elif grains['oscodename'] == 'stretch' %}:
    - fromrepo: unstable
  {%- endif %}
{%- elif grains['node_type'] == 'vmware' %}
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
{%- if salt['pillar.get']('X11:Xfce:enabled') -%}
      - synapse
{%- endif %}
      - xsel
{%- if salt['pillar.get']('libreoffice:enabled') %}
      - libreoffice
{%- endif %}
{%- if salt['pillar.get']('pidgin:enabled') %}
      - pidgin
{%- endif %}

# Browsers

browsers:
  pkg.installed:
    - pkgs:
      - firefox
{%- if salt['pillar.get']('firefox:mp3_support') %}
      - gstreamer1.0-plugins-ugly
{%- endif %}
      - chromium
{%- if salt['pillar.get']('profile-sync-daemon:enabled') %}
      - profile-sync-daemon
{%- endif %}
{%- if grains['oscodename'] in ['wheezy', 'jessie'] %}
    - fromrepo: {{ grains['oscodename'] }}-backports
{%- endif %}

# Fonts

font-packages:
  pkg.installed:
    - pkgs:
      # multipurpose
      - fonts-noto
      - fonts-roboto
      # console/programming
      - fonts-droid
      # emoji
      - fonts-knda
      - fonts-lklug-sinhala
      - fonts-tibetan-machine
      - fonts-vlgothic
      - ttf-ancient-fonts
      - unifont

{% set user_font_dir = "/home/{}/.local/share/fonts".format(grains['username']) %}
user-font-dir:
  file.directory:
    - name: {{ user_font_dir }}
    - user: {{ grains['username'] }}

font-droid-sans-mono-slashed:
  archive.extracted:
    - name: {{ user_font_dir }}
    - source: http://www.cosmix.org/software/files/DroidSansMonoSlashed.zip
    - source_hash: sha256=71768814dc4de0ea6248d09a2d2285bd47e9558f82945562eb78487c71348107
    - archive_format: zip
{%- if grains['saltversioninfo'] >= [2016, 11, 0] %}
    - enforce_toplevel: false
{%- endif %}
    - if_missing: {{ user_font_dir }}/DroidSansMonoSlashed.ttf
    - require:
      - pkg: unzip
      - file: user-font-dir

{# zip_options is the blocker #}
{%- if grains['saltversioninfo'] >= [2016, 9, 0] %}
font-fira-code:
  archive.extracted:
    - name: {{ user_font_dir }}
    - source: https://github.com/tonsky/FiraCode/releases/download/1.204/FiraCode_1.204.zip
    - source_hash: sha256=28ccc003173cec9de7857f8743b805d6b51eb68fb8be5e21ce2f8e1584f0939f
    - archive_format: zip

{%- if grains['saltversioninfo'] >= [2016, 11, 0] %}
    - source_hash_update: true
    - enforce_toplevel: false
    - options: -j -i *.ttf
{% else %}
    - zip_options: -j -i *.ttf
{%- endif %}
    - if_missing: {{ user_font_dir }}/FiraCode-Regular.ttf
    - require:
      - pkg: unzip
      - file: user-font-dir
{%- endif %}

# Theme-related
themes:
  pkg.installed:
    - pkgs:
      - gnome-wise-icon-theme
{%- if salt['pillar.get']('X11:Xfce:enabled') -%}
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

{%- if salt['pillar.get']('X11:Xfce:enabled') -%}
/etc/lightdm/lightdm-gtk-greeter.conf:
  file.managed:
    - source: salt://desktop/files/lightdm-gtk-greeter.conf.jinja
    - template: jinja
    - require:
      - pkg: lightdm
      - file: {{ wallpaper['filename'] }}
{%- endif %}
