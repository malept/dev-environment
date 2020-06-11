{% from 'node/map.jinja' import npm_requirement, npmrc with context %}

include:
  - .dasht
  - .git
  - .grep
  - .vagrant
  - .vim

{%- if not grains['kernelrelease'].endswith('-Microsoft') %}
America/Los_Angeles:
  timezone.system:
    - utc: True
{%- endif %}

tops:
  pkg.installed:
    - pkgs:
      - htop
      - iftop

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

{%- if salt['pillar.get']('grunt:enabled') %}
grunt-cli:
  npm.installed:
    - user: {{ grains['username'] }}
    - require:
      - {{ npm_requirement }}
      - file: {{ npmrc }}
      - file: npm-global-dir
{%- endif %}

/usr/local/bin:
  file.directory

jq:
  pkg.installed

{%- set xsv_version = salt['pillar.get']('xsv:version', false) %}
{%- if xsv_version %}
xsv:
  archive.extracted:
    - name: /usr/local/bin/
    - source: https://github.com/BurntSushi/xsv/releases/download/{{ xsv_version }}/xsv-{{ xsv_version }}-{{ grains['cpuarch'] }}-unknown-linux-musl.tar.gz
    - source_hash: {{ salt['pillar.get']('xsv:checksum') }}
    - archive_format: tar
{%- if grains['saltversioninfo'] >= [2016, 11, 0] %}
    - enforce_toplevel: false
    - source_hash_update: true
    - options: z
{%- else %}
    - tar_options: z
{%- endif %}
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

{%- set shellcheck_version = salt['pillar.get']('shellcheck:version') %}
{%- if shellcheck_version %}
shellcheck:
  archive.extracted:
    - name: /usr/local/bin/
    - source: https://github.com/koalaman/shellcheck/releases/download/v{{ shellcheck_version }}/shellcheck-v{{ shellcheck_version }}.{{ grains['kernel'].lower() }}.{{ grains['cpuarch'] }}.tar.xz
    - enforce_toplevel: False
    - skip_verify: True
    - options: --wildcards */shellcheck --strip-components 1
    - if_missing: /usr/local/bin/shellcheck
    - require:
      - file: /usr/local/bin
{%- endif %}

{%- set shfmt_version = salt['pillar.get']('shfmt:version') %}
{%- if shfmt_version %}
/usr/local/bin/shfmt:
  file.managed:
    - source: https://github.com/mvdan/sh/releases/download/v{{ shfmt_version }}/shfmt_v{{ shfmt_version }}_{{ grains['kernel'].lower() }}_{{ grains['osarch'] }}
    - source_hash: {{ salt['pillar.get']('shfmt:source_hash') }}
    - mode: 0755
{%- endif %}
