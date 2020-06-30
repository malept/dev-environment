{% from 'node/map.jinja' import npm_requirement, npmrc with context -%}
{% from 'wsl.jinja' import is_wsl -%}

include:
{%- if salt['pillar.get']('chef:enabled', false) %}
  - .chef
{%- endif %}
  - .dasht
  - .git
  - .grep
  - .shell
  - .vagrant
  - .vim

{%- if not is_wsl %}
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
