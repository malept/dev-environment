include:
  - nginx

{% macro vhost_config(dest_filename, template_path, config, enabled) -%}
/etc/nginx/sites-available/{{ dest_filename }}:
  file.managed:
    - source: salt://{{ template_path }}.jinja
    - mode: 644
    - template: jinja
    - context:
      config: config
    - watch_in:
      service: nginx

{% if enabled -%}
/etc/nginx/sites-enabled/{{ dest_filename }}:
  file.symlink:
    - target: ../sites-available/{{ dest_filename }}
    - watch_in:
      service: nginx
{% endif -%}
{% endmacro -%}

{% for vhost, vhost_cfg in salt['pillar.get']('nginx:vhosts', {}) -%}
{{ vhost_config('{0}.conf'.format(vhost), 'webserver/files/nginx_vhost.conf', vhost_cfg|json, true) }}
{% endfor -%}
