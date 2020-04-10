{% set apt_key = 'https://packages.cloud.google.com/apt/doc/apt-key.gpg' -%}
{% set local_apt_key = '/usr/share/keyrings/cloud.google.gpg' -%}
google-cloud-sdk:
  {# Work around the lack of `apt-key --keyring` support in pkgrepo #}
  file.managed:
    - name: {{ local_apt_key }}
    - source: {{ apt_key }}
    - skip_verify: True
  pkgrepo.managed:
    - name: "deb [signed-by={{ local_apt_key }}] https://packages.cloud.google.com/apt cloud-sdk main"
    - humanname: Google Cloud SDK
    - file: /etc/apt/sources.list.d/google-cloud-sdk.list
    - requires:
      - file: google-cloud-sdk
  pkg.installed:
    - requires:
      - pkgrepo: google-cloud-sdk

