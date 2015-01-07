{% from 'venv_bin.sls' import venv_with_binary with context -%}

snakefire-deps:
  pkg.installed:
    - pkgs:
      - python-qt4
      - python-keyring
      - python-gnomekeyring
      - python-notify
      - python-enchant
      - aspell-en
      - python-dev
      - libffi-dev

python-six:
  pkg.installed{%- if grains['oscodename'] == 'wheezy' %}:
    - dist: wheezy-backports
{%- endif %}

{{ venv_with_binary('snakefire', 'snakefire', 'salt://desktop/files/snakefire-requirements.txt', ('pkg', 'snakefire-deps'), ('pkg', 'python-six')) }}

/home/{{ grains['username'] }}/.local/share/applications/cricava-snakefire.desktop:
  file.symlink:
    - target: /home/{{ grains['username'] }}/.local/share/virtualenv/snakefire/src/snakefire/packaging/linux/cricava-snakefire.desktop
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - makedirs: True

/home/{{ grains['username'] }}/.local/share/icons/hicolor/scalable/apps/cricava-snakefire.png:
  file.symlink:
    - target: /home/{{ grains['username'] }}/.local/share/virtualenv/snakefire/src/snakefire/resources/snakefire.png
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - makedirs: True
