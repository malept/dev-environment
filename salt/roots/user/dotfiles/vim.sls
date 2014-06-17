vim:
  pkg.installed:
    - pkgs:
{%- if salt['pillar.get']('vim:gtk') %}
      - vim-gtk
{%- else %}
      - vim-nox
{%- endif %}
{%- if salt['pillar.get']('vim:ctags') %}
      - exuberant-ctags
{%- endif %}

vimfiles:
  git.latest:
    - name: https://github.com/malept/vimfiles.git
    - rev: master
    - submodules: True
    - target: /home/{{ grains['username'] }}/Code/vimfiles
    - user: {{ grains['username'] }}
    - require:
      - pkg: vim

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
