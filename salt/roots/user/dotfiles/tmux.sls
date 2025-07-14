{% from 'user/dotfiles/macros.sls' import bin_file, config_dir, config_file with context %}

tmux:
  pkg.installed:
    - require:
      - pkg: ncurses-term

{# For the tmux-256color terminfo #}
ncurses-term:
  pkg.installed

{{ config_file('tmux.conf', '.config/tmux/tmux.conf', templated=true) }}

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
