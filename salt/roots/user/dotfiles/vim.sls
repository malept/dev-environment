{% set vim_enabled = salt['pillar.get']('vim:enabled') %}
{% set neovim_enabled = salt['pillar.get']('neovim:enabled') %}

{%- if vim_enabled or neovim_enabled %}
vimfiles:
  git.latest:
    - name: https://github.com/malept/vimfiles.git
    - rev: main
    - submodules: True
    - target: /home/{{ grains['username'] }}/Code/vimfiles
    - user: {{ grains['username'] }}
    - require:
{%- if vim_enabled %}
      - pkg: vim
{%- endif %}
{%- if neovim_enabled %}
      - pkg: neovim
{%- endif %}
      - pkg: git

{%- if neovim_enabled %}
/home/{{ grains['username'] }}/.config/nvim:
  file.directory:
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - dir_mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
    - require:
      - git: vimfiles

/home/{{ grains['username'] }}/.config/nvim/init.vim:
  file.symlink:
    - target: /home/{{ grains['username'] }}/Code/vimfiles/vimrc
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - mode: 644
    - require:
      - file: /home/{{ grains['username'] }}/.config/nvim
      - git: vimfiles
{%- endif %}

{%- macro user_vim_dir(name) %}
/home/{{ grains['username'] }}/.local/share/vim/{{ name }}:
  file.directory:
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - dir_mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
    - require:
      - git: vimfiles
{%- endmacro %}

{{ user_vim_dir('backup') }}
{{ user_vim_dir('session') }}
{{ user_vim_dir('swap') }}
{{ user_vim_dir('undo') }}
{%- endif %}
