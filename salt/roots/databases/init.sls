{% set mysql_version = salt['pillar.get']('mysql:version', false) -%}
{%- if mysql_version %}
{%- set mysql_majmin = '{0}.{1}'.format(mysql_version['major'], mysql_version['minor']) %}
mysql:
  pkg.installed:
    - pkgs:
      - mysql-client-{{ mysql_majmin }}
      - mysql-server-{{ mysql_majmin }}
      - mysql-workbench
      - libmysqlclient-dev

  service:
    - running
    - enable: True
    - require:
      - pkg: mysql
{%- endif %}

{% set elasticsearch_version = salt['pillar.get']('elasticsearch:version', false) -%}
{%- if elasticsearch_version %}
elasticsearch:
  pkg.installed:
    - sources:
      - elasticsearch: https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-{{ elasticsearch_version }}.deb
{%- endif %}

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
{%- endif %}{# cassandra #}

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
