{%- if salt['pillar.get']('nginx:manage', true) %}
include:
  - nginx
{%- endif %}

{%- if salt['pillar.get']('nginx:expires', true) %}
/usr/share/nginx/logs:
  file.symlink:
    - target: /var/log/nginx
{%- endif %}

{% macro vhost_config(app_name, template_path, config, enabled) -%}
{% set dest_filename = '{0}.conf'.format(app_name) -%}
{% set hostname = config.pop('hostname', '{0}.test'.format(app_name.replace('_', '-'))) -%}
nginx-vhost-{{ app_name }}:
  file.managed:
    - name: /etc/nginx/sites-available/{{ dest_filename }}
    - source: salt://{{ template_path }}.jinja
    - mode: 644
    - template: jinja
    - context:
      app_name: {{ app_name }}
      config: {{ config|json() }}
      hostname: {{ hostname }}
    - watch_in:
      service: nginx
{%- if salt['pillar.get']('nginx:expires', true) %}
    - require:
      - file: /usr/share/nginx/logs
{%- endif %}

  host.present:
    - name: {{ hostname }}
    - ip: 127.0.1.1

{% if enabled -%}
/etc/nginx/sites-enabled/{{ dest_filename }}:
  file.symlink:
    - target: ../sites-available/{{ dest_filename }}
    - watch_in:
      service: nginx
{% endif -%}
{% endmacro -%}

{% for vhost, vhost_cfg in salt['pillar.get']('nginx:vhosts', {}).iteritems() -%}
{{ vhost_config(vhost, 'webserver/files/nginx_vhost.conf', vhost_cfg, true) }}
{% endfor -%}
