{% from 'user/dotfiles/macros.sls' import bin_file, config_dir, config_file with context %}

tmux:
  pkg.installed{%- if grains['oscodename'] == 'jessie' %}:
    - fromrepo: debian.jessie-backports
{%- elif grains['oscodename'] == 'xenial' %}:
    - sources:
      - tmux: http://mirrors.kernel.org/ubuntu/pool/main/t/tmux/tmux_2.2-3_amd64.deb
{%- endif %}

{{ config_file('tmux.conf', '.config/tmux/tmux.conf') }}

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
