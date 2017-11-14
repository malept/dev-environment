{% set elasticsearch_version = salt['pillar.get']('elasticsearch:version', false) -%}
{%- if elasticsearch_version %}
java-runtime:
  pkg.installed:
    - name: default-jre-headless
elasticsearch:
  pkg.installed:
    - sources:
      {%- if elasticsearch_version.startswith(('0', '1')) %}
      - elasticsearch: https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-{{ elasticsearch_version }}.deb
      {%- elif elasticsearch_version.startswith('2') %}
      - elasticsearch: https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/{{ elasticsearch_version }}/elasticsearch-{{ elasticsearch_version }}.deb
      {%- else %}
      - elasticsearch: https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-{{ elasticsearch_version }}.deb
      {%- endif %}
    - require:
      - pkg: java-runtime
  service.running:
    - enable: True
    - require:
      - pkg: elasticsearch
{%- endif %}
