America/Los_Angeles:
  timezone.system:
    - utc: True

tops:
  pkg.installed:
    - pkgs:
      - htop
      - iftop

silversearcher-ag:
{%- if grains['oscodename'] == 'wheezy' %}
  pkg.installed:
    - sources:
      - the-silver-searcher: http://swiftsignal.com/packages/ubuntu/quantal/the-silver-searcher_0.14-1_amd64.deb
{%- else %}
  pkg.installed
{%- endif %}

tmux:
{%- if grains['oscodename'] == 'wheezy' %}
  pkg.installed:
    - fromrepo: wheezy-backports
{%- else %}
  pkg.installed
{%- endif %}

git:
  pkg.installed

sshfs:
  pkg.installed

unzip:
  pkg.installed

python-pip:
  pkg.installed

python-virtualenv:
  pkg.installed

{%- if salt['pillar.get']('xlsx2csv:enabled', false) %}
{% from 'venv_bin.sls' import venv_with_binary with context -%}
{{ venv_with_binary('xlsx2csv', 'xlsx2csv', 'salt://system/files/xlsx2csv-requirements.txt') }}
{%- endif %}

{%- if salt['pillar.get']('imagemagick:enabled', false) %}
imagemagick:
  pkg.installed
{%- endif %}

{%- if salt['pillar.get']('chef:enabled', false) %}
chef:
  pkg.installed

{%- if salt['pillar.get']('aws:enabled', false) %}
ruby-dev:
  pkg.installed

knife-ec2:
  gem.installed:
    - require:
      - pkg: chef
      - pkg: ruby-dev
{%- endif %}
{%- endif %}
