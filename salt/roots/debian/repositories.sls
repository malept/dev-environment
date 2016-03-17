{%- if grains['oscodename'] == 'wheezy' -%}
debian.wheezy-backports:
  pkgrepo.managed:
    - humanname: Debian Wheezy backports repository
    - name: deb http://mirrors.kernel.org/debian wheezy-backports main contrib
    - dist: wheezy-backports
    - file: /etc/apt/sources.list.d/wheezy-backports.list
{%- endif %}

{%- if grains['oscodename'] in ['wheezy', 'jessie'] %}
pkg-mozilla-archive-keyring:
  pkg.installed

debian.{{ grains['oscodename'] }}-mozilla:
  pkgrepo.managed:
    - humanname: Debian {{ grains['oscodename'] }} Mozilla repository
    - name: deb http://mozilla.debian.net/ {{ grains['oscodename'] }}-backports firefox-release
    - dist: {{ grains['oscodename'] }}-backports
    - file: /etc/apt/sources.list.d/{{ grains['oscodename'] }}-mozilla.list
    - require:
      - pkg: pkg-mozilla-archive-keyring
{%- endif %}

{% if grains['os'] == 'Debian' and salt['pillar.get']('debian:repos:jessie', true) -%}
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
    - name: deb http://mirrors.kernel.org/debian sid main contrib
    - dist: sid
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
{% endif %}
