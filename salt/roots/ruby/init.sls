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

{% if salt['pillar.get']('ruby:capybara-webkit:enabled') -%}
capybara-webkit-deps:
  pkg.installed:
    - pkgs:
      - qt4-qmake
      - libqt4-dev
{%- endif %}
{%- if salt['pillar.get']('ruby:checkers:enabled') %}
{%- set ruby_checker = salt['pillar.get']('ruby:checkers:rvm_ruby') %}
{%- set gemset_checker = salt['pillar.get']('ruby:checkers:rvm_gemset', 'static_analysis') %}
{%- set checker_list = salt['pillar.get']('ruby:checkers:names') %}
checkers:
  rvm.gemset_present:
    - name: {{ gemset_checker }}
    - ruby: {{ ruby_checker }}
    - user: {{ grains['username'] }}
    - require:
      - rvm: {{ ruby_checker }}
  gem.installed:
    - names:
{%- for checker in checker_list %}
      - {{ checker }}
{%- endfor %}
    - ruby: {{ ruby_checker }}@{{ gemset_checker }}
    - user: {{ grains['username'] }}
    - require:
      - rvm: {{ gemset_checker }}

/home/{{ grains['username'] }}/.local/bin/static_analysis_wrapper:
  file.managed:
    - source: salt://ruby/files/static_analysis_wrapper.jinja
    - template: jinja
    - context:
      ruby: {{ ruby_checker }}
      gemset: {{ gemset_checker }}
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - mode: 755

{%- for checker in checker_list %}
/home/{{ grains['username'] }}/.local/bin/{{ checker }}:
  file.symlink:
    - target: /home/{{ grains['username'] }}/.local/bin/static_analysis_wrapper
    - require:
      - file: /home/{{ grains['username'] }}/.local/bin/static_analysis_wrapper
{%- endfor %}
{%- endif %}
