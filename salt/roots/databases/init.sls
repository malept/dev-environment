{#
Pillars:
* memcached:enabled
* redis:enabled
#}
include:
  - .elasticsearch
  - .mysql

{% if salt['pillar.get']('memcached:enabled') -%}
memcached:
  pkg.installed
{%- endif %}

{% if salt['pillar.get']('redis:enabled') -%}
redis:
  pkg.installed:
    - name: redis-server
{%- endif %}
