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
  pkg.latest:
{%- if grains['oscodename'] == 'wheezy' %}
    - dist: wheezy-backports
{%- endif %}

/home/{{ grains['username'] }}/.local/share/virtualenv/snakefire:
  virtualenv.managed:
    - user: {{ grains['username'] }}
    - system_site_packages: True
    - requirements: salt://desktop/files/snakefire-requirements.txt
    - require:
      - pkg: snakefire-deps
      - pkg: python-six
      - pkg: python-virtualenv

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

/home/{{ grains['username'] }}/.local/bin/snakefire:
  file.symlink:
    - target: /home/{{ grains['username'] }}/.local/share/virtualenv/snakefire/bin/snakefire
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - makedirs: True
