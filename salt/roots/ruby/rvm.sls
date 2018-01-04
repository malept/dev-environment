rvm-deps:
  pkg.installed:
    - names:
      - bash
      - coreutils
      - gzip
      - bzip2
      - gawk
      - sed
      - curl
      - git
      - gnupg
  cmd.run:
    - user: {{ grains['username'] }}
    - name: gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
    - unless: gpg --fingerprint | fgrep 'Key fingerprint = 409B 6B17 96C2 7546 2A17  0311 3804 BB82 D39D C0E3'

mri-deps:
  pkg.installed:
    - names:
      - build-essential
      - openssl
      - libreadline6
      - libreadline6-dev
      - curl
      - git
      - zlib1g
      - zlib1g-dev
      - libssl-dev
      - libyaml-dev
      - libsqlite3-0
      - libsqlite3-dev
      - sqlite3
      - libxml2-dev
      - libxslt1-dev
      - autoconf
      - libc6-dev
      - libncurses5-dev
      - automake
      - libtool
      - bison
      - ruby

{% set ruby_versions = salt['pillar.get']('ruby:versions', []) -%}
{% set ruby_default_version = salt['pillar.get']('ruby:default_version', false) -%}
{% for version in ruby_versions -%}
{{ version }}:
  rvm.installed:
{% if version == ruby_default_version %}
    - default: True
{% endif %}
    - user: {{ grains['username'] }}
    - require:
      - pkg: rvm-deps
      - cmd: rvm-deps
      - pkg: mri-deps
{% endfor -%}
