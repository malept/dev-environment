{%- macro config_file(src, dest=false) %}
{%- if not dest %}
{%- set dest = '.{}'.format(src) %}
{%- endif %}
/home/{{ grains['username'] }}/{{ dest }}:
  file.managed:
    - source: salt://user/dotfiles/files/{{ src }}
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - mode: 644
    - makedirs: True
{%- endmacro %}

{{ config_file('bash_aliases') }}
{{ config_file('gitconfig') }}
{{ config_file('gitignore', '.config/git/ignore') }}
{{ config_file('profile') }}
