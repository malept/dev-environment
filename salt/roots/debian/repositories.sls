{%- if grains['oscodename'] in ['jessie', 'stretch'] -%}
debian.{{ grains['oscodename'] }}-backports:
  pkgrepo.managed:
    - humanname: Debian {{ grains['oscodename'] }} backports repository
    - name: deb http://mirrors.kernel.org/debian {{ grains['oscodename'] }}-backports main contrib non-free
    - dist: {{ grains['oscodename'] }}-backports
    - file: /etc/apt/sources.list.d/backports.list
{%- endif %}

{% if grains['os'] == 'Debian' and salt['pillar.get']('debian:repos:jessie', false) -%}
debian.jessie:
  pkgrepo.managed:
    - humanname: Debian Jessie repository
    - name: deb http://mirrors.kernel.org/debian jessie main contrib
    - dist: jessie
    - file: /etc/apt/sources.list.d/jessie.list

/etc/apt/preferences.d/jessie.pref:
  file.managed:
    - source: salt://debian/files/apt_preferences.jessie.conf
    - user: root
    - group: root
    - mode: 644
{%- endif %}

{% if salt['pillar.get']('debian:repos:sid') -%}
debian.sid:
  pkgrepo.managed:
    - humanname: Debian Sid repository
    - name: deb http://mirrors.kernel.org/debian unstable main contrib
    - dist: unstable
    - file: /etc/apt/sources.list.d/sid.list

/etc/apt/preferences.d/sid.pref:
  file.managed:
    - source: salt://debian/files/apt_preferences.sid.conf
    - user: root
    - group: root
    - mode: 644
{%- endif %}

{% if salt['pillar.get']('debian:repos:experimental') %}
debian.experimental:
  pkgrepo.managed:
    - humanname: Debian Experimental repository
    - name: deb http://mirrors.kernel.org/debian experimental main contrib
    - dist: experimental
    - file: /etc/apt/sources.list.d/experimental.list
{% endif %}

{% if salt['pillar.get']('debian:repos:personal') %}
debian.personal:
  pkgrepo.managed:
    - humanname: Personal Debian APT repository
    - name: deb [trusted=yes] https://apt.fury.io/malept/ /
    - file: /etc/apt/sources.list.d/personal.list
{%- if grains['os'] == 'Debian' and grains['osrelease']|float < 10 %}
    - require:
      - pkg: apt-transport-https
{%- endif %}

{% if grains['os'] == 'Debian' and grains['osrelease']|float < 10 -%}
apt-transport-https:
  pkg.installed
{%- endif %}
{% endif %}
{% if salt['pillar.get']('node:install_from_ppa') and 'deb.nodesource.com' in salt['pillar.get']('node:ppa:repository_url', '') -%}
/etc/apt/preferences.d/nodesource.pref:
  file.managed:
    - source: salt://debian/files/apt_preferences.nodesource.conf
    - user: root
    - group: root
    - mode: 644
{%- endif %}
