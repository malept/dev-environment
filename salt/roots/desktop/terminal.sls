wezterm:
  pkgrepo.managed:
    - name: 'deb [signed-by=/etc/apt/trusted.gpg.d/wezterm-keyring.gpg arch={{ grains['osarch'] | lower }}] https://apt.fury.io/wez/ * *'
    - humanname: Wezterm
    - file: /etc/apt/sources.list.d/wezterm.list
    - key_url: https://apt.fury.io/wez/gpg.key
    - signedby: /etc/apt/keyrings/wezterm-keyring.gpg
    - aptkey: False
    - require_in:
      - pkg: wezterm
  pkg.installed:
    - refresh: True
