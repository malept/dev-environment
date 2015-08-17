{% if grains['os'] == 'Ubuntu' %}
deadsnakes.ppa:
  pkgrepo.managed:
    - humanname: Deadsnakes PPA
    - name: deb http://ppa.launchpad.net/fkrull/deadsnakes/ubuntu precise main
    - dist: precise
    - file: /etc/apt/sources.list.d/deadsnakes.list
    - keyid: DB82666C
    - keyserver: keyserver.ubuntu.com
    - require_in:
      pkg:
        - python2.6-dev
        - python3.3-dev
        - python3.4-dev

pypy.ppa:
  pkgrepo.managed:
    - humanname: PyPy PPA
    - name: deb http://ppa.launchpad.net/pypy/ppa/ubuntu precise main
    - dist: precise
    - file: /etc/apt/sources.list.d/pypy.list
    - keyid: "68854915"
    - keyserver: keyserver.ubuntu.com
    - require_in:
      pkg: pypy-dev
{% endif %}

python-devel:
  pkg.installed:
    - names:
{%- if not (grains['os'] == 'Debian' and grains['osrelease'] >= 8.0) %}
      - python2.6-dev
{%- endif %}
      - python2.7-dev
{%- if grains['os'] != 'Debian' %}
      - python3.3-dev
{%- endif %}
      - pypy-dev

{% if grains['cpuarch'] == 'x86_64' %}{% set bits = '64' %}{% else %}{% set bits = '' %}{% endif %}
{% set pypy3_basename = 'pypy3-{}-linux{}'.format(salt['pillar.get']('python:pypy3:version'), bits) %}
pypy3:
  archive.extracted:
    - name: /opt/
    - source: https://bitbucket.org/pypy/pypy/downloads/{{ pypy3_basename }}.tar.bz2
    - source_hash: sha256={{ salt['pillar.get']('python:pypy3:binary_sha256') }}
    - archive_format: tar
    - if_missing: /opt/{{ pypy3_basename }}/

/usr/local/bin/pypy3:
  file.symlink:
    - target: /opt/{{ pypy3_basename }}/bin/pypy3