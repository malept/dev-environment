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
