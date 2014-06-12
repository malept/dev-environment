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
      - git-core
      - subversion

mri-deps:
  pkg.installed:
    - names:
      - build-essential
      - openssl
      - libreadline6
      - libreadline6-dev
      - curl
      - git-core
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
      - subversion
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
      - pkg: mri-deps
{% endfor -%}

capybara-webkit-deps:
  pkg.installed:
    - pkgs:
      - qt4-qmake
      - libqt4-dev
