nodejs:
  pkg.installed:
    - names:
      - nodejs-legacy

{% set npm_version = salt['pillar.get']('npm:version', false) -%}
{% if npm_version and grains['oscodename'] == 'wheezy' -%}
{% set local_tgz = '/usr/src/npm/npm-{0}.tgz'.format(npm_version) -%}
get-npm:
  file.managed:
    - name: {{ local_tgz }}
    - source: http://registry.npmjs.org/npm/-/npm-{{ npm_version }}.tgz
    - source_hash: sha1={{ salt['pillar.get']('npm:sha1sum') }}
    - user: {{ grains['username'] }}
    - makedirs: True
    - require:
      - pkg: nodejs
  cmd.wait:
    - cwd: /usr/src/npm
    - user: {{ grains['username'] }}
    - names:
      - tar xf {{ local_tgz }}
    - creates: /usr/src/npm/package
    - watch:
      - file: {{ local_tgz }}

install-npm:
  file.directory:
    - name: /opt/node
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - dir_mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
    - watch:
      - cmd: get-npm
  cmd.wait:
    - cwd: /usr/src/npm/package
    - user: {{ grains['username'] }}
    - env:
      - npm_config_prefix: /opt/node
    - names:
      - ./configure --prefix=/opt/node; test -f npmrc
      - node cli.js install marked
      - make install
      - test -f /opt/node/lib/node_modules/npm/bin/npm-cli.js; chmod +x /opt/node/lib/node_modules/npm/bin/npm-cli.js
    - creates: /opt/node/bin/npm
    - watch:
      - file: /opt/node

/opt/node/bin/npm:
  file.exists:
    - require:
      - cmd: install-npm

{%- set npm_deptype = 'file' %}
npm:
  file.symlink:
    - name: /usr/local/bin/npm
    - target: /opt/node/bin/npm
    - require:
      - cmd: install-npm
      - file: /opt/node/bin/npm
{%- else %}
{%- set npm_deptype = 'pkg' %}
npm:
  pkg.installed
{%- endif %}

node-linters:
  npm.installed:
    - names:
      - coffeelint
      - csslint
      - jshint
    - require:
      - {{ npm_deptype }}: npm
