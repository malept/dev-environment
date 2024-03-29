{% from 'node/map.jinja' import npm_requirement, npmrc with context -%}
{% from 'rust.sls' import cargo_install with context %}
{% from 'wsl.jinja' import is_wsl -%}

include:
{%- if salt['pillar.get']('chef:enabled', false) %}
  - .chef
{%- endif %}
  - .dasht
  - .git
  - .grep
  - .neovim
  - .shell
  - .vagrant

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

{%- if salt['pillar.get']('imagemagick:enabled', false) %}
imagemagick:
  pkg.installed
{%- endif %}

{%- set grpcurl_version = salt['pillar.get']('grpcurl:version') %}
{%- if grpcurl_version %}
{%- set grpcurl_base_url = 'https://github.com/fullstorydev/grpcurl/releases/download/v{}'.format(grpcurl_version) %}
grpcurl:
  archive.extracted:
    - name: /usr/local/bin/
    # Both platform and arch are non-standard (linux|osx|windows, x86_32|x86_64)
    - source: {{ grpcurl_base_url }}/grpcurl_{{ grpcurl_version }}_{{ grains['kernel'].lower() }}_x86_64.tar.gz
    - source_hash: {{ grpcurl_base_url }}/grpcurl_{{ grpcurl_version }}_checksums.txt
    - source_hash_update: true
    - enforce_toplevel: false
    - options: --wildcards grpcurl
    - if_missing: /usr/local/bin/grpcurl
    - require:
      - file: /usr/local/bin
{%- endif %}

jq:
  pkg.installed

{%- if salt['pillar.get']('rust:enabled') %}
{%- if salt['pillar.get']('watchexec:enabled') %}
{{ cargo_install('watchexec-cli', 'watchexec') }}
{%- endif %}
{%- if salt['pillar.get']('xsv:enabled') %}
{{ cargo_install('xsv') }}
{%- endif %}
{%- endif %}

{%- if is_wsl and grains['os'] == 'Debian' %}
wslu:
  pkg.installed:
    - require:
      - pkgrepo: wslu
  pkgrepo.managed:
    - name: "deb https://pkg.wslutiliti.es/debian {{ grains['oscodename'] }} main"
    - file: /etc/apt/sources.list.d/wslu.list
    - key_url: https://pkg.wslutiliti.es/public.key

/usr/local/bin/xdg-open:
  file.symlink:
    - target: /usr/bin/wslview
{%- endif %}
