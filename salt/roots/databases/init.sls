{#
Pillars:
* memcached:enabled
* rabbitmq:enabled
* redis:enabled
#}
include:
  - .cassandra
  - .couchdb
  - .elasticsearch
  - .mysql

{% if salt['pillar.get']('memcached:enabled') -%}
memcached:
  pkg.installed
{%- endif %}

{%- if salt['pillar.get']('rabbitmq:enabled') %}
rabbitmq-server:
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
