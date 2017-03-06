node:
  install_from_ppa: true
{%- if grains['oscodename'] == 'stretch' %}
  ppa:
    dist: jessie # stretch does not exist as a dist yet
{%- endif %}
npm:
  config:
    prefix: /opt/node
python:
  pypy3:
    version: v5.2.0-alpha1
    binary_sha256: f5e66ab24267d6ddf662d07c512d06c10ebc732ae62093dabbd775ac63b9060a
