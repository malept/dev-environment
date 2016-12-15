android-sdk:
  archive.extracted:
    - name: /opt/
    - archive_format: zip
    - source: https://dl.google.com/android/repository/tools_r25.2.3-linux.zip
    - source_hash: sha1=aafe7f28ac51549784efc2f3bdfc620be8a08213
{%- if grains['saltversioninfo'] >= [2015, 8, 0] %}
    - user: root
    - group: users
{%- else %}
    - archive_user: root
{%- endif %}
    - if_missing: /opt/android-sdk-linux
{%- if grains['saltversioninfo'] >= [2016, 3, 0] %}
    - source_hash_update: true
{%- endif %}
    - require:
      - pkg: android-sdk-deps

android-sdk-deps:
  pkg.installed:
    - pkgs:
      - lib32stdc++6
      - lib32z1

/etc/udev/rules.d/51-android.rules:
  file.managed:
    - source: salt://android/files/51-android.rules
    - user: root
    - group: root
    - mode: 644
    - require:
      - archive: android-sdk
