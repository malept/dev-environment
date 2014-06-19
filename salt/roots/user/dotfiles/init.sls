{%- macro config_file(src, dest=false, templated=false) %}
{%- if not dest %}
{%- set dest = '.{}'.format(src) %}
{%- endif %}
/home/{{ grains['username'] }}/{{ dest }}:
  file.managed:
    - source: salt://user/dotfiles/files/{{ src }}
{%- if templated %}
    - template: jinja
{%- endif %}
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - mode: 644
    - makedirs: True
{%- endmacro %}

{{ config_file('bash_aliases') }}
{{ config_file('bashrc', templated=true) }}
{{ config_file('gitconfig', templated=true) }}
{{ config_file('gitignore', '.config/git/ignore') }}
{{ config_file('profile') }}
{{ config_file('gemrc') }}
