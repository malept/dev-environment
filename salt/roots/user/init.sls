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
      - floppy
      - fuse
      - netdev
      - plugdev
      - scanner
      - users
      - video
