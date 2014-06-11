{% set mysql_version = salt['pillar.get']('mysql:version', false) -%}
{%- if mysql_version %}
{%- set mysql_majmin = '{0}.{1}'.format(mysql_version['major'], mysql_version['minor']) %}
mysql:
  pkg.installed:
    - pkgs:
      - mysql-client-{{ mysql_majmin }}
      - mysql-server-{{ mysql_majmin }}
{%- endif %}

{% set elasticsearch_version = salt['pillar.get']('elasticsearch:version', false) -%}
{%- if elasticsearch_version %}
elasticsearch:
  pkg.installed:
    - sources:
      - elasticsearch: https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-{{ elasticsearch_version }}.deb
{%- endif %}
