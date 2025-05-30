{%- set pillar_get = salt['pillar.get'] %}
{%- if grains['os'] == 'Ubuntu' %}
git-ppa:
  pkgrepo.managed:
    - ppa: git-core/ppa
    - require_in:
      - pkg: git
{%- endif %}

git:
  pkg.installed{% if grains['oscodename'] == 'buster' %}:
    - fromrepo: {{ grains['oscodename'] }}-backports
{%- endif %}

{%- if pillar_get('git:lfs:enabled') %}
git-lfs:
  pkgrepo.managed:
    - humanname: Git-LFS
    - name: deb https://packagecloud.io/github/git-lfs/{{ grains['os']|lower }}/ {{ grains['oscodename'] }} main
    - dist: {{ grains['oscodename'] }}
    - file: /etc/apt/sources.list.d/git-lfs.list
    - key_url: https://packagecloud.io/github/git-lfs/gpgkey
    - require_in:
      - pkg: git-lfs
  pkg.installed:
    - refresh: True
{%- endif %}
