{{ grains['username'] }}:
  user.present:
    - remove_groups: false
{%- if salt['pillar.get']('user.managed', true) %}
    - groups:
      - sudo
    - optional_groups:
      - adm
      - audio
      - bluetooth
      - cdrom
      - dip
      - docker
{%- if salt['pillar.get']('elasticsearch:version', false) %}
      - elasticsearch
{%- endif %}
      - floppy
      - fuse
      - netdev
      - plugdev
      - scanner
      - users
      - vboxusers
      - video
{%- set extra_groups = salt['pillar.get']('user.extra_groups') %}
{%- if extra_groups %}
{%- for group in extra_groups %}
      - {{ group }}
{%- endfor %}
{%- endif %}
{%- endif %}
    - require:
      - pkg: sshfs # so the fuse group is added correctly
