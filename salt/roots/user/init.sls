{{ grains['username'] }}:
  user.present:
    - groups:
      - sudo
    - optional_groups:
      - adm
      - audio
      - bluetooth
      - cdrom
      - dip
      - docker
      - floppy
      - fuse
      - netdev
      - plugdev
      - scanner
      - users
      - vboxusers
      - video
    - require:
      - pkg: sshfs # so the fuse group is added correctly

{%- if salt['pillar.get']('X11:enabled') and salt['pillar.get']('X11:Xfce:enabled') %}
include:
  .xfce
{%- endif %}
