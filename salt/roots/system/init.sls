{% from 'node/map.jinja' import npm_requirement, npmrc with context %}

include:
  - .dasht
  - .neovim

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

{%- set fzy_version = salt['pillar.get']('fzy:version') %}
{%- if fzy_version %}
fzy:
  pkg.installed:
    - sources:
      - fzy: https://github.com/jhawthorn/fzy/releases/download/{{ fzy_version }}/fzy_{{ fzy_version }}-1_amd64.deb
    - version: {{ fzy_version }}
{%- endif %}

{%- if salt['pillar.get']('profile-sync-daemon:enabled') and salt['pillar.get']('profile-sync-daemon:overlayfs') %}
/etc/sudoers.d/profile-sync-daemon:
  file.managed:
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - source: salt://system/files/profile-sync-daemon.sudoers
    - check_cmd: visudo -c -f
    - require:
      - pkg: browsers
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

npmrc-dir:
  file.directory:
    - name: /usr/etc
    - require_in:
      - file: {{ npmrc }}

grunt-cli:
  npm.installed:
    - user: {{ grains['username'] }}
    - require:
      - {{ npm_requirement }}
      - file: {{ npmrc }}
      - file: npm-global-dir

{% set vagrant_version = salt['pillar.get']('vagrant:version', false) -%}
{% if vagrant_version -%}
{% set vagrant_deb = '/var/cache/apt/archives/vagrant_{}_x86_64.deb'.format(vagrant_version) %}
{{ vagrant_deb }}:
  file.managed:
    - source: https://releases.hashicorp.com/vagrant/{{ vagrant_version }}/vagrant_{{ vagrant_version }}_x86_64.deb
    - source_hash: https://releases.hashicorp.com/vagrant/{{ vagrant_version }}/vagrant_{{ vagrant_version }}_SHA256SUMS
    - if_missing: /opt/vagrant/embedded/gems/cache/vagrant-{{ vagrant_version }}.gem
vagrant:
  pkg.installed:
    - sources:
      - vagrant: {{ vagrant_deb }}
    - version: {{ vagrant_version }}
    - require:
      - file: {{ vagrant_deb }}
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
{%- if grains['saltversioninfo'] >= [2016, 3, 0] %}
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

{%- if salt['pillar.get']('aws:enabled') %}
ruby-dev:
  pkg.installed

knife-ec2:
  gem.installed:
    - require:
      - pkg: chef
      - pkg: ruby-dev
{%- endif %}
{%- endif %}
