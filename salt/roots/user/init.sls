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
    - require:
      - pkg: sshfs # so the fuse group is added correctly

{% from 'wallpaper.sls' import wallpaper -%}

desktop_prefs:
  xfce.desktop_preferences:
    - user: {{ grains['username'] }}
    - create_if_not_exists: True
    - require:
      - pkg: xfce
    - /backdrop/screen0/monitor0/image-path: {{ wallpaper['filename'] }}
    - /backdrop/screen0/monitor0/image-show: True
    - /backdrop/screen0/monitor0/last-image: {{ wallpaper['filename'] }}
    - /backdrop/screen0/monitor0/last-single-image: {{ wallpaper['filename'] }}
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
    - require:
      - pkg: xfce
    - /compat/LaunchGNOME: True

wm_prefs:
  xfce.wm_preferences:
    - user: {{ grains['username'] }}
    - require:
      - pkg: xfce
    - use_compositing: True

panel_prefs:
  xfce.panel_preferences:
    - user: {{ grains['username'] }}
    - create_if_not_exists: True
    - require:
      - pkg: xfce
    - /panels: 1
    - /panels/panel-0/length: 100
    - /panels/panel-0/plugin-ids:
      - 1
      - 3
      - 4
      - 8
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
    - /plugins/plugin-8: screenshooter

xsettings_prefs:
  xfce.xsettings_preferences:
    - user: {{ grains['username'] }}
    - create_if_not_exists: True
    - require:
      - pkg: xfce
    - /Net/IconThemeName: gnome-wise
    - /Net/ThemeName: Shiki-Wise
    - /Xft/Antialias: 1
    - /Xft/HintStyle: hintfull
    - /Xft/RGBA: rgb
