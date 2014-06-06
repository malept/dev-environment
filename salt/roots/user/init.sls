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

{%- set wallpaper = '/home/{}/Pictures/BusquedaNocturna.jpg'.format(grains['username']) %}
{{ wallpaper }}:
  file.managed:
    - source: https://farm4.staticflickr.com/3498/3177079486_94b257b10f_o_d.jpg
    - source_hash: sha256=8451fb81cd1cc0318817dcfd7d8f42a3740f52ce2243023d191a88e0b102b03c
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - mode: 644
    - makedirs: True

user_desktop_prefs:
  xfce.desktop_preferences:
    - user: {{ grains['username'] }}
    - create_if_not_exists: True
    - /backdrop/screen0/monitor0/image-path: {{ wallpaper }}
    - /backdrop/screen0/monitor0/image-show: True
    - /backdrop/screen0/monitor0/last-image: {{ wallpaper }}
    - /backdrop/screen0/monitor0/last-single-image: {{ wallpaper }}
    - /desktop-icons/file-icons/show-filesystem: False
    - /desktop-icons/file-icons/show-home: False
    - /desktop-icons/file-icons/show-removable: False
    - /desktop-icons/file-icons/show-trash: False
    - /desktop-icons/icon-size: 48
    - /windowlist-menu/show: False

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
