/etc/bash_completion.d/apt:
  file.managed:
    - source: salt://debian/files/apt.bash_completion
    - user: root
    - group: root
    - mode: 644
