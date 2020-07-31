google-cloud-sdk:
  pkgrepo.managed:
    - name: "deb https://packages.cloud.google.com/apt cloud-sdk main"
    - humanname: Google Cloud SDK
    - file: /etc/apt/sources.list.d/google-cloud-sdk.list
    - key_url: https://packages.cloud.google.com/apt/doc/apt-key.gpg
  pkg.installed:
    - requires:
      - pkgrepo: google-cloud-sdk

