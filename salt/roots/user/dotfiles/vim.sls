https://github.com/malept/vimfiles.git:
  git.latest:
    - rev: master
    - submodules: True
    - target: /home/{{ grains['username'] }}/Code/vimfiles

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
{%- endmacro %}

{{ user_vim_dir('swap') }}
{{ user_vim_dir('undo') }}
{{ user_vim_dir('backup') }}
