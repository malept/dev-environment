#
# Pillars:
# mysql:
#   enabled: true
#   server: false
# X11:
#   enabled: true # for mysql-workbench
#

{% set mysql_server = salt['pillar.get']('mysql:server') -%}
{%- if salt['pillar.get']('mysql:enabled', false) %}
mysql:
  pkg.installed:
    - pkgs:
      - mysql-community-client
      - libmysqlclient-dev
{%- if mysql_server %}
      - mysql-community-server
{%- endif %}
{%- if salt['pillar.get']('X11:enabled') %}
      - mysql-workbench
{%- endif %}
{%- if grains['os'] == 'Debian' %}
    - require:
      - pkg: mysql-apt-config

{%- if mysql_server %}
  service:
    - running
    - enable: True
    - require:
      - pkg: mysql
{%- endif %}
{%- endif %}

{%- if grains['os'] == 'Debian' %}
mysql-apt-config:
  pkg.installed:
    - sources:
      - mysql-apt-config: https://dev.mysql.com/get/mysql-apt-config_0.8.15-1_all.deb
{%- endif %}
{%- endif %}
