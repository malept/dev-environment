{%- if salt['pillar.get']('ruby:checkers:enabled') %}
{%- set ruby_checker = salt['pillar.get']('ruby:checkers:rvm_ruby') %}
{%- set gemset_checker = salt['pillar.get']('ruby:checkers:rvm_gemset', 'static_analysis') %}
{%- set checker_list = salt['pillar.get']('ruby:checkers:names') %}
checkers:
  rvm.gemset_present:
    - name: {{ gemset_checker }}
    - ruby: {{ ruby_checker }}
    - user: {{ grains['username'] }}
    - require:
      - rvm: {{ ruby_checker }}
  gem.installed:
    - names:
{%- for checker in checker_list %}
      - {{ checker }}
{%- endfor %}
    - ruby: {{ ruby_checker }}@{{ gemset_checker }}
    - user: {{ grains['username'] }}
    - require:
      - rvm: {{ gemset_checker }}

/home/{{ grains['username'] }}/.local/bin/static_analysis_wrapper:
  file.managed:
    - source: salt://ruby/files/static_analysis_wrapper.jinja
    - template: jinja
    - context:
      ruby: {{ ruby_checker }}
      gemset: {{ gemset_checker }}
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - mode: 755
    - makedirs: true

{%- for checker in checker_list %}
/home/{{ grains['username'] }}/.local/bin/{{ checker }}:
  file.symlink:
    - target: /home/{{ grains['username'] }}/.local/bin/static_analysis_wrapper
    - makedirs: true
    - require:
      - file: /home/{{ grains['username'] }}/.local/bin/static_analysis_wrapper
{%- endfor %}
{%- endif %}

{% from 'node/map.jinja' import npm_requirement, npmrc with context %}
node-linters:
  npm.installed:
    - user: {{ grains['username'] }}
    - names:
      - coffeelint
      - csslint
      - jshint
      - jsonlint
    - require:
      - {{ npm_requirement }}
      - file: {{ npmrc }}
