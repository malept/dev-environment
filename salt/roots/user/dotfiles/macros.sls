{%- macro bin_file(src, dest=false, srcdir="bin", destdir=".local/bin") %}
{%- if not dest %}
{%- set dest = src %}
{%- endif %}
/home/{{ grains['username'] }}/{{ destdir }}/{{ dest }}:
  file.managed:
    - source: salt://user/dotfiles/files/{{ srcdir }}/{{ src }}
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - mode: 755
    - makedirs: True
{%- endmacro %}

{%- macro config_file(src, dest=false, templated=false, req_in=[]) %}
{%- if not dest %}
{%- set dest_override = salt['pillar.get']('user:dotfiles:{}'.format(src)) %}
{%- set dest = dest_override or '.{}'.format(src) %}
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
{%- if req_in %}
    - require_in:
{%- for req in req_in %}
      - {{ req[0] }}: {{ req[1] }}
{%- endfor %}
{%- endif %}
{%- endmacro %}

{%- macro config_dir(name) %}
/home/{{ grains['username'] }}/{{ name }}:
  file.directory:
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - makedirs: true
{%- endmacro %}
