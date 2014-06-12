/home/{{ grains['username'] }}/.local/share/virtualenv/aws:
  virtualenv.managed:
    - user: {{ grains['username'] }}
    - system_site_packages: True
    - requirements: salt://aws/files/awscli-requirements.txt
    - require:
      - pkg: python-virtualenv

/home/{{ grains['username'] }}/.local/bin/aws:
  file.symlink:
    - target: /home/{{ grains['username'] }}/.local/share/virtualenv/aws/bin/aws
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - makedirs: True
