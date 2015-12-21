# vim: set ft=sls ts=2 sts=2 sw=2 et :
base:
  '*':
{%- if grains['os'] == 'Debian' %}
    - debian
{%- endif %}
    - user
    - user.dotfiles
    - user.dotfiles.node
    - user.dotfiles.vim
    - system
{%- if salt['pillar.get']('X11:enabled') %}
    - desktop
{%- endif %}
{%- if salt['pillar.get']('campfire:enabled') %}
    - desktop.snakefire
{%- endif %}
{%- if salt['pillar.get']('github:enabled') %}
    - github
{%- endif %}
{%- if salt['pillar.get']('python:enabled', true) %}
    - python
{%- endif %}
{%- if salt['pillar.get']('ruby:enabled') %}
    - ruby
{%- endif %}
    - databases
{%- if salt['pillar.get']('postgres:enabled', true) %}
    - postgres.apt
    - postgres
    - postgres.config
{%- if salt['pillar.get']('postgres:pgadmin3:enabled') %}
    - postgres.pgadmin3
{%- endif %}
{%- endif %}
{%- if salt['pillar.get']('aws:enabled') %}
    - aws
{%- endif %}
{%- if grains['os'] in ['Debian', 'Ubuntu'] and salt['pillar.get']('heroku:enabled') %}
    - heroku
{%- endif %}
{%- if salt['pillar.get']('dropbox:enabled') %}
    - dropbox
{%- endif %}
    - node
    - static-analysis
    - phantomjs
{%- if salt['pillar.get']('webserver:enabled', true) %}
    - webserver
{%- endif %}
{%- if salt['pillar.get']('gmusicprocurator:enabled') %}
    - gmusicprocurator
{%- endif %}
