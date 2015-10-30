{% set elasticsearch_version = salt['pillar.get']('elasticsearch:version', false) -%}
{%- if elasticsearch_version %}
elasticsearch:
  pkg.installed:
    - sources:
      {%- if elasticsearch_version.startswith(('0', '1')) %}
      - elasticsearch: https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-{{ elasticsearch_version }}.deb
      {%- else %}
      - elasticsearch: https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/{{ elasticsearch_version }}/elasticsearch-{{ elasticsearch_version }}.deb
      {%- endif %}
{%- endif %}
