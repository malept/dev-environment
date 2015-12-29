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

{%- macro config_dir(name) %}
/home/{{ grains['username'] }}/{{ name }}:
  file.directory:
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - makedirs: true
{%- endmacro %}
