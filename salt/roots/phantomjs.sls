{% set pjs_version = salt['pillar.get']('phantomjs:version', false) %}
{%- if pjs_version %}
{%- set pjs_basename = 'phantomjs-{0}-linux-{1}'.format(pjs_version, grains['cpuarch']) -%}
phantomjs:
{%- if grains['oscodename'] in ['wheezy', 'jessie'] %}
  archive.extracted:
    - name: /opt/
    - source: https://bitbucket.org/ariya/phantomjs/downloads/{{ pjs_basename }}.tar.bz2
    - source_hash: sha256=473b19f7eacc922bc1de21b71d907f182251dd4784cb982b9028899e91dcb01a
    - archive_format: tar
{%- if grains['saltversioninfo'] >= [2016, 11, 0] %}
    - options: j
{%- else %}
    - tar_options: j
{%- endif %}
    - if_missing: /opt/{{ pjs_basename }}/
    - require_in:
      - file: /usr/local/bin/phantomjs

  file.symlink:
    - name: /usr/local/bin/phantomjs
    - target: /opt/{{ pjs_basename }}/bin/phantomjs
{%- else %}
  pkg.installed
{%- endif %}
{%- endif -%}
