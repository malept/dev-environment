{%- set pillar_get = salt['pillar.get'] %}
{%- set ruby_manager = pillar_get('ruby:manager', 'rvm') %}

include:
{%- if ruby_manager == 'rvm' %}
  - .rvm
{%- elif ruby_manager == 'chruby' %}
  - .chruby
{%- endif %}

{%- if pillar_get('ruby:capybara-webkit:enabled') %}
capybara-webkit-deps:
  pkg.installed:
    - pkgs:
      - qt4-qmake
      - libqt4-dev
{%- endif %}
