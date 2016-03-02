android-sdk:
  archive.extracted:
    - name: /opt/
    - archive_format: tar
    - source: http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
    - source_hash: sha1=725bb360f0f7d04eaccff5a2d57abdd49061326d
    - tar_options: z
{%- if grains['saltversioninfo'] >= (2015, 8, 0) %}
    - user: root
    - group: users
{%- else %}
    - archive_user: root
{%- endif %}
    - if_missing: /opt/android-sdk-linux
