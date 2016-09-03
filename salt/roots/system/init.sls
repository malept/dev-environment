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

{%- set fzy_version = salt['pillar.get']('fzy:version') %}
{%- if fzy_version %}
fzy:
  pkg.installed:
    - sources:
      - fzy: https://github.com/jhawthorn/fzy/releases/download/{{ fzy_version }}/fzy_{{ fzy_version }}-1_amd64.deb
    - version: {{ fzy_version }}
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

npm-global-dir:
  file.directory:
    - name: {{ salt['pillar.get']('npm:config:prefix') }}
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}

grunt-cli:
  npm.installed:
    - user: {{ grains['username'] }}
    - require:
      - {{ npm_requirement }}
      - file: npm-global-dir

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

{%- set xsv_version = salt['pillar.get']('xsv:version', false) %}
{%- if xsv_version %}
xsv:
  archive.extracted:
    - name: /usr/local/bin/
    - source: https://github.com/BurntSushi/xsv/releases/download/{{ xsv_version }}/xsv-{{ xsv_version }}-{{ grains['cpuarch'] }}-unknown-linux-musl.tar.gz
    - source_hash: {{ salt['pillar.get']('xsv:checksum') }}
{%- if grains['saltversioninfo'] >= (2016, 3, 0) %}
    - source_hash_update: true
{%- endif %}
    - archive_format: tar
    - tar_options: z
    - if_missing: /usr/local/bin/xsv
{%- endif %}

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
