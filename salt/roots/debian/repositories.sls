{%- set pillar_get = salt['pillar.get'] %}
{% if pillar_get('debian:repos:backports') -%}
debian.{{ grains['oscodename'] }}-backports:
  pkgrepo.managed:
    - humanname: Debian {{ grains['oscodename'] }} backports repository
    - name: deb http://mirrors.kernel.org/debian {{ grains['oscodename'] }}-backports main contrib non-free
    - dist: {{ grains['oscodename'] }}-backports
    - file: /etc/apt/sources.list.d/backports.list
{%- endif %}

{% if pillar_get('debian:repos:sid') -%}
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

{% if pillar_get('debian:repos:experimental') %}
debian.experimental:
  pkgrepo.managed:
    - humanname: Debian Experimental repository
    - name: deb http://mirrors.kernel.org/debian experimental main contrib
    - dist: experimental
    - file: /etc/apt/sources.list.d/experimental.list
{% endif %}

{% if pillar_get('debian:repos:personal') %}
debian.personal:
  pkgrepo.managed:
    - humanname: Personal Debian APT repository
    - name: deb [trusted=yes] https://apt.fury.io/malept/ /
    - file: /etc/apt/sources.list.d/personal.list
{%- endif %}
