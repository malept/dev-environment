{% set vim_enabled = salt['pillar.get']('vim:enabled', true) %}
{% set neovim_enabled = salt['pillar.get']('neovim:enabled') %}

{%- if vim_enabled or neovim_enabled %}
vimfiles:
  git.latest:
    - name: https://github.com/malept/vimfiles.git
    - rev: master
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

/home/{{ grains['username'] }}/.config/nvim:
  file.directory:
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - file_mode: 644
    - dir_mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode
    - require:
      - git: vimfiles

{%- macro user_vim_dir(name) %}
/home/{{ grains['username'] }}/.local/share/vim/{{ name }}:
  file.directory:
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - file_mode: 644
    - dir_mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode
    - require:
      - git: vimfiles
{%- endmacro %}

{{ user_vim_dir('swap') }}
{{ user_vim_dir('undo') }}
{{ user_vim_dir('backup') }}
{%- endif %}
