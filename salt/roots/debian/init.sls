debian.wheezy-backports:
  pkgrepo.managed:
    - humanname: Debian Wheezy backports repository
    - name: deb http://mirrors.kernel.org/debian wheezy-backports main contrib
    - dist: wheezy-backports
    - file: /etc/apt/sources.list.d/wheezy-backports.list

pkg-mozilla-archive-keyring:
  pkg.installed

debian.wheezy-mozilla:
  pkgrepo.managed:
    - humanname: Debian Wheezy Mozilla repository
    - name: deb http://mozilla.debian.net/ wheezy-backports iceweasel-release
    - dist: wheezy-backports
    - file: /etc/apt/sources.list.d/wheezy-mozilla.list
    - require:
      - pkg: pkg-mozilla-archive-keyring

{% if salt['pillar.get']('debian:repos:jessie') -%}
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
