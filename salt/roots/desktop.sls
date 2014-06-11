xfce:
  pkg.installed:
    - pkgs:
      - xfce4
      - xfce4-indicator-plugin

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

gnome-keyring:
  pkg.installed

synapse:
  pkg.installed

# Browsers

iceweasel:
  pkg.installed:
{%- if grains['oscodename'] == 'wheezy' %}
    - fromrepo: wheezy-backports
{%- endif %}

chromium:
  pkg.installed

# Fonts

droid-sans-mono-slashed:
  archive.extracted:
    - name: /home/{{ grains['username'] }}/.fonts/
    - source: http://www.cosmix.org/software/files/DroidSansMonoSlashed.zip
    - source_hash: sha256=71768814dc4de0ea6248d09a2d2285bd47e9558f82945562eb78487c71348107
    - archive_format: zip
    - if_missing: /home/{{ grains['username'] }}/.fonts/DroidSansMonoSlashed.ttf
    - requires:
      - pkg: unzip

font-packages:
  pkg.installed:
    - pkgs:
      # console/programming
      - fonts-droid
      # emoji
      - fonts-knda
      - fonts-lklug-sinhala
      - fonts-tibetan-machine
      - ttf-ancient-fonts

# Theme-related
themes:
  pkg.installed:
    - pkgs:
      - gnome-wise-icon-theme
      - shiki-colors-xfwm-theme
      - shiki-wise-theme
