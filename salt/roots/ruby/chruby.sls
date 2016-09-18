{%- set pillar_get = salt['pillar.get'] %}

chruby:
  pkg.installed:
    - require:
      - pkgrepo: debian.personal

ruby-install:
  pkg.installed:
    - require:
      - pkgrepo: debian.personal

mri-deps:
  pkg.installed:
    - pkgs:
      - libgdbm-dev
      - libncurses5-dev
      - libreadline-dev
      - libyaml-dev

{% set ruby_versions = pillar_get('ruby:versions', []) -%}
{% for version in ruby_versions -%}
{{ version }}:
  cmd.run:
    - name: ruby-install {{ version }} -- --enable-shared
    - creates: /opt/rubies/{{ version }}
    - require:
      - pkg: mri-deps
{% endfor -%}
