{%- if salt['pillar.get']('couchdb:enabled') %}
couchdb:
  pkg.installed

couchdb-repo:
  pkgrepo.managed:
    - name: "deb https://apache.bintray.com/couchdb-deb {{ grains['oscodename'] }} main"
    - keyid: 8756C4F765C9AC3CB6B85D62379CE192D401AB61
    - keyserver: keyserver.ubuntu.com
    - file: /etc/apt/sources.list.d/couchdb.list
    - require_in:
      - pkg: couchdb
{%- endif %}
