{% set cassandra_version = salt['pillar.get']('cassandra:version', false) -%}
{%- if cassandra_version %}
cassandra:
{%- if grains['os'] == 'Debian' %}
  {%- set cassandra_dist = '{0}{1}x'.format(cassandra_version['major'], cassandra_version['minor']) %}
  pkgrepo.managed:
    - humanname: Apache Cassandra {{ cassandra_version['major'] }}.{{ cassandra_version['minor'] }}.x
    - name: deb http://www.apache.org/dist/cassandra/debian {{ cassandra_dist }} main
    - dist: {{ cassandra_dist }}
    - file: /etc/apt/sources.list.d/logstash.list
    - keyid: 2B5C1B00
    - keyserver: pgp.mit.edu
    - require_in:
      - pkg: cassandra
{%- endif %}

  pkg.installed:
    - refresh: True

cqlsh-deps:
  pkg.installed:
    - pkgs:
      - python-concurrent.futures
      - python-six
      - python-snappy
      - libev-dev
    - require_in:
      - pip: cassandra-driver
  pip.installed:
    - name: cassandra-driver
{%- endif %}
