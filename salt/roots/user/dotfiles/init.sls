{%- macro bin_file(src, dest=false) %}
{%- if not dest %}
{%- set dest = src %}
{%- endif %}
/home/{{ grains['username'] }}/.local/bin/{{ dest }}:
  file.managed:
    - source: salt://user/dotfiles/files/bin/{{ src }}
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - mode: 755
    - makedirs: True
{%- endmacro %}

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

{{ bin_file('awsify') }}
{{ bin_file('blade') }}

{{ config_file('agignore') }}
{{ config_file('bash_aliases') }}
{{ config_file('bashrc', templated=true) }}
{{ config_file('gitconfig', templated=true) }}
{{ config_file('gitignore', '.config/git/ignore') }}
{{ config_file('profile') }}
{{ config_file('gemrc') }}
{{ config_file('irbrc') }}
{{ config_file('npmrc') }}
{{ config_file('synapse-gtkrc', '.config/synapse/gtkrc') }}
{{ config_file('xfce4-screenshooter', '.config/xfce4/xfce4-screenshooter', templated=true) }}
