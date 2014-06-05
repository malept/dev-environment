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

user_session_prefs:
  xfce.session_preferences:
    - user: {{ grains['username'] }}
    - create_if_not_exists: True
    - /startup/ssh-agent/enabled: True
    - /startup/ssh-agent/type: gnome-keyring-daemon

user_wm_prefs:
  xfce.wm_preferences:
    - user: {{ grains['username'] }}
    - use_compositing: True
