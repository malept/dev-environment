{% from 'node/map.jinja' import npm_requirement with context %}
{% from 'venv_bin.sls' import venv_with_binary with context %}

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
  pkg.installed{%- if salt['pillar.get']('debian:repos:personal') %}:
    - fromrepo: debian.personal
{%- endif %}

{%- if salt['pillar.get']('neovim:enabled') %}
{%- if salt['pillar.get']('debian:repos:personal') %}
neovim:
  pkg.installed:
    - fromrepo: debian.personal
    - require:
      - pkg: neovim-runtime-deps
{%- elif grains['os'] == 'Ubuntu' %}
neovim:
  pkg.installed:
    - fromrepo: neovim
    - require:
      - pkgrepo: neovim
      - pkg: neovim-runtime-deps
  pkgrepo.managed:
    - ppa: neovim-ppa/unstable
{%- endif %}

neovim-runtime-deps:
  pkg.installed:
    - pkgs:
      - editorconfig
{%- if salt['pillar.get']('vim:ctags') %}
      - exuberant-ctags
{%- endif %}

{%- if salt['pillar.get']('neovim:remote:enabled') %}
{{ venv_with_binary('neovim-remote', 'nvr', 'salt://system/files/neovim-remote-requirements.txt', python='/usr/bin/python3') }}
{%- endif %}
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

grunt-cli:
  npm.installed:
    - require:
      - {{ npm_requirement }}

{% set vagrant_version = salt['pillar.get']('vagrant:version', false) -%}
{% if vagrant_version -%}
vagrant:
  pkg.installed:
    - sources:
      - vagrant: https://releases.hashicorp.com/vagrant/{{ vagrant_version }}/vagrant_{{ vagrant_version }}_x86_64.deb
    - version: {{ vagrant_version }}
{%- endif %}

/usr/local/bin:
  file.directory

{%- if salt['pillar.get']('imagemagick:enabled', false) %}
imagemagick:
  pkg.installed
{%- endif %}

{%- if salt['pillar.get']('chef:enabled', false) %}
chef:
  pkg.installed

chef-client:
  service.dead:
    - enable: False

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
