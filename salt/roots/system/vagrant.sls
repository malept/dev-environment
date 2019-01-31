{% set vagrant_version = salt['pillar.get']('vagrant:version', false) -%}
{% if vagrant_version -%}
{% set vagrant_deb_filename = 'vagrant_{}_{}.deb'.format(vagrant_version, grains['cpuarch']) -%}
{% set vagrant_deb = '/var/cache/apt/archives/{}'.format(vagrant_deb_filename) -%}
{{ vagrant_deb }}:
  file.managed:
    - source: https://releases.hashicorp.com/vagrant/{{ vagrant_version }}/{{ vagrant_deb_filename }}
    - source_hash: https://releases.hashicorp.com/vagrant/{{ vagrant_version }}/vagrant_{{ vagrant_version }}_SHA256SUMS
    - if_missing: /opt/vagrant/embedded/gems/cache/vagrant-{{ vagrant_version }}.gem
vagrant:
  pkg.installed:
    - sources:
      - vagrant: {{ vagrant_deb }}
    - version: {{ vagrant_version }}
    - require:
      - file: {{ vagrant_deb }}
{%- endif %}
