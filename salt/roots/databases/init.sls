include:
  - .mysql
  - .elasticsearch
  - .cassandra

{% if salt['pillar.get']('memcached:enabled') -%}
memcached:
  pkg.installed
{%- endif %}

{% if salt['pillar.get']('redis:enabled') -%}
redis:
  pkg.installed:
    - name: redis-server
{%- if grains['oscodename'] == 'wheezy' %}
    - fromrepo: wheezy-backports
{%- endif %}
{%- endif %}
