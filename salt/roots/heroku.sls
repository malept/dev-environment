heroku:
  pkgrepo.managed:
    - humanname: Heroku toolbelt repository
    - name: deb http://toolbelt.heroku.com/ubuntu ./
    - dist: ./
    - file: /etc/apt/sources.list.d/heroku.list
    - key_url: https://toolbelt.heroku.com/apt/release.key
    - require_in:
      - pkg: heroku
  pkg.installed:
    - pkgs:
      - heroku-toolbelt
    - refresh: True
