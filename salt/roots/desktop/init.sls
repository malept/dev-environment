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

{%- if grains['node_type'] == 'vagrant' %}
virtualbox-guest-x11:
  pkg.installed:
  {%- if grains['oscodename'] == 'wheezy' %}
    - fromrepo: wheezy-backports
  {%- endif %}
{%- elif grains['node_type'] == 'vmware' %}
open-vm-tools-desktop:
  pkg.installed:
  {%- if grains['oscodename'] == 'wheezy' %}
    - fromrepo: wheezy-backports
  {%- endif %}
{%- endif %}

desktop-apps:
  pkg.installed:
    - pkgs:
      - file-roller
      - gnome-keyring
      - gucharmap
      - synapse
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
{%- if grains['os'] == 'Debian' %}
      - iceweasel
{%- else %}
      - firefox
{%- endif %}
{%- if salt['pillar.get']('firefox:mp3_support') %}
      - gstreamer1.0-plugins-ugly
{%- endif %}
      - chromium
{%- if grains['oscodename'] == 'wheezy' %}
    - fromrepo: wheezy-backports
{%- endif %}

octosplit-firefox:
  file.managed:
    - name: /home/{{ grains['username'] }}/.mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/octosplit.xpi
    - source: https://addons.mozilla.org/firefox/downloads/file/266454/octosplit-0.0.12-fx.xpi
    - source_hash: sha256=0a7c035598c0c80952ce3c9f7f2d9e0dfb92db8eff9e3e33e4ed542a6de3b63e
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - makedirs: True

# Fonts

font-packages:
  pkg.installed:
    - pkgs:
      # console/programming
      - fonts-droid
      # emoji
      - fonts-knda
      - fonts-lklug-sinhala
      - fonts-tibetan-machine
      - fonts-vlgothic
      - ttf-ancient-fonts
      - unifont

  ## Droid Sans Mono Slashed
  archive.extracted:
    - name: /home/{{ grains['username'] }}/.fonts/
    - source: http://www.cosmix.org/software/files/DroidSansMonoSlashed.zip
    - source_hash: sha256=71768814dc4de0ea6248d09a2d2285bd47e9558f82945562eb78487c71348107
    - archive_format: zip
    - if_missing: /home/{{ grains['username'] }}/.fonts/DroidSansMonoSlashed.ttf
    - require:
      - pkg: unzip

# Theme-related
themes:
  pkg.installed:
    - pkgs:
      - gnome-wise-icon-theme
      - shiki-colors-xfwm-theme
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

/etc/lightdm/lightdm-gtk-greeter.conf:
  file.managed:
    - source: salt://desktop/files/lightdm-gtk-greeter.conf.jinja
    - template: jinja
    - require:
      - pkg: lightdm
      - file: {{ wallpaper['filename'] }}
