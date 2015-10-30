{% set elasticsearch_version = salt['pillar.get']('elasticsearch:version', false) -%}
{%- if elasticsearch_version %}
elasticsearch:
  pkg.installed:
    - sources:
      - elasticsearch: https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-{{ elasticsearch_version }}.deb
{%- endif %}
