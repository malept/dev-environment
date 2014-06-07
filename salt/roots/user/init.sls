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

desktop_prefs:
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

session_prefs:
  xfce.session_preferences:
    - user: {{ grains['username'] }}
    - create_if_not_exists: True
    - /startup/ssh-agent/enabled: True
    - /startup/ssh-agent/type: gnome-keyring-daemon

wm_prefs:
  xfce.wm_preferences:
    - user: {{ grains['username'] }}
    - use_compositing: True

panel_prefs:
  xfce.panel_preferences:
    - user: {{ grains['username'] }}
    - create_if_not_exists: True
    - /panels: 1
    - /panels/panel-0/length: 100
    - /panels/panel-0/plugin-ids:
      - 1
      - 3
      - 4
      - 2
      - 6
      - 5
      - 7
    - /panels/panel-0/position: p=6;x=0;y=0
    - /panels/panel-0/position-locked: True
    - /plugins/plugin-1: applicationsmenu
    - /plugins/plugin-1/show-button-title: False
    - /plugins/plugin-1/show-tooltips: True
    - /plugins/plugin-2: indicator
    - /plugins/plugin-3: tasklist
    - /plugins/plugin-4: pager
    - /plugins/plugin-5: clock
    - /plugins/plugin-6: systray
    - /plugins/plugin-7: xfsm-logout-plugin
