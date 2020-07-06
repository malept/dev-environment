{%- set pypy_enabled = salt['pillar.get']('python:pypy:enabled') %}
{%- set pypy3_enabled = salt['pillar.get']('python:pypy3:enabled') %}

{%- if grains['os'] == 'Ubuntu' %}
{%- set deadsnakes = salt['pillar.get']('python:deadsnakes') %}
{%- if deadsnakes %}
deadsnakes.ppa:
  pkgrepo.managed:
    - ppa: deadsnakes/ppa
    - require_in:
      pkg:
{%- for python_version in deadsnakes %}
        - python{{ python_version }}-dev
{%- endfor %}
{%- endif %}

{%- if pypy_enabled or pypy3_enabled %}
pypy.ppa:
  pkgrepo.managed:
    - ppa: pypy/ppa
    - require_in:
{%- if pypy_enabled %}
      - pkg: pypy-dev
{%- endif %}
{%- if pypy3_enabled %}
      - pkg: pypy3-dev
{%- endif %}
{%- endif %}
{%- endif %}

python-devel:
  pkg.installed:
    - names:
{%- if salt['pillar.get']('python:python2') %}
      - python-dev
{%- endif %}
      - python3-dev
{%- if pypy_enabled %}
      - pypy-dev
{%- endif %}
{%- if pypy3_enabled %}
      - pypy3-dev
{%- endif %}

{%- if salt['pillar.get']('python:python2') %}
python-pip:
  pkg.installed

python-virtualenv:
  pkg.installed
{%- endif %}

python3-virtualenv:
  pkg.installed
