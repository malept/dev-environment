{% from 'user/dotfiles/macros.sls' import bin_file, config_dir, config_file with context %}

tmux:
  pkg.installed{%- if grains['oscodename'] in ['jessie', 'stretch'] %}:
    - fromrepo: {{ grains['oscodename'] }}-backports
    - require:
      - pkgrepo: debian.{{ grains['oscodename'] }}-backports
{%- elif grains['oscodename'] == 'xenial' %}:
    - sources:
      - tmux: http://ftp.us.debian.org/debian/pool/main/t/tmux/tmux_2.3-4~bpo8+1_amd64.deb
{%- endif %}

{{ config_file('tmux.conf', '.config/tmux/tmux.conf', templated=true) }}

/home/{{ grains['username'] }}/.tmux.conf:
  file.symlink:
    - target: /home/{{ grains['username'] }}/.config/tmux/tmux.conf
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - require:
      - file: /home/{{ grains['username'] }}/.config/tmux/tmux.conf


tmux-plugins:
  file.directory:
    - name: /home/{{ grains['username'] }}/.config/tmux/plugins
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - makedirs: True
    - require:
      - pkg: tmux

tmux-tpm:
  git.latest:
    - name: https://github.com/tmux-plugins/tpm.git
    - rev: master
    - target: /home/{{ grains['username'] }}/.config/tmux/plugins/tpm
    - user: {{ grains['username'] }}
    - require:
      - pkg: git
      - file: tmux-plugins
