{% from "node/map.jinja" import default_npm_prefix, npm_prefix, npmrc with context %}
{% if default_npm_prefix != npm_prefix %}
{{ npm_prefix }}:
  file.directory:
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - require_in:
      - file: {{ npmrc }}
{% endif %}
