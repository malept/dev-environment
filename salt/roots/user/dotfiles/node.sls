{% from 'user/dotfiles/macros.sls' import config_file with context %}

{{ config_file('npmrc') }}

/opt/node:
  file.directory:
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - require_in:
      - file: /home/{{ grains['username'] }}/.npmrc

