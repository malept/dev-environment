# vim: set ft=sls ts=2 sts=2 sw=2 et :
base:
  '*':
{%- if grains['os'] == 'Debian' %}
    - debian
{%- endif %}
    - user
    - user.dotfiles
    - user.dotfiles.vim
    - system
    - desktop
{%- if salt['pillar.get']('campfire:enabled') %}
    - desktop.snakefire
{%- endif %}
{%- if salt['pillar.get']('ruby:enabled') %}
    - ruby
{%- endif %}
    - databases
    - postgres.apt
    - postgres
    - postgres.config
{%- if salt['pillar.get']('aws:enabled') %}
    - aws
{%- endif %}
    - nodejs
    - phantomjs
    - webserver
