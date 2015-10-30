{% set mysql_version = salt['pillar.get']('mysql:version', false) -%}
{%- if mysql_version %}
{%- set mysql_majmin = '{0}.{1}'.format(mysql_version['major'], mysql_version['minor']) %}
mysql:
  pkg.installed:
    - pkgs:
      - mysql-client-{{ mysql_majmin }}
      - mysql-server-{{ mysql_majmin }}
{%- if salt['pillar.get']('X11:enabled') %}
      - mysql-workbench
{%- endif %}
      - libmysqlclient-dev

  service:
    - running
    - enable: True
    - require:
      - pkg: mysql
{%- endif %}
