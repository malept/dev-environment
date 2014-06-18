dropbox-deps:
  pkg.installed:
    - pkgs:
      - python-gpgme

# XXX May have to hardcode *arch to i386 if 32-bit machine
dropbox:
  pkg.installed:
    - sources:
{%- if grains['os'] in ['Debian', 'Ubuntu'] %}
      - dropbox: https://www.dropbox.com/download?dl=packages/debian/dropbox_{{ salt['pillar.get']('dropbox:version') }}_{{ grains['osarch'] }}.deb
{%- elif grains['os'] == 'Fedora' %}
      - dropbox: https://www.dropbox.com/download?dl=packages/fedora/nautilus-dropbox-{{ salt['pillar.get']('dropbox:version') }}.fedora.{{ grains['cpuarch'] }}.rpm
{%- endif %}
    - require:
      - pkg: dropbox-deps
