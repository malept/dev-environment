{%- set keyring = "/etc/apt/trusted.gpg.d/mise-archive-keyring.gpg" %}
mise:
  pkgrepo.managed:
    - name: 'deb [signed-by={{ keyring }} arch={{ salt['grains.get']('osarch') | lower }}] https://mise.jdx.dev/deb stable main'
    - dist: stable
    - humanname: Nushell
    - key_url: https://mise.jdx.dev/gpg-key.pub
    - aptkey: False
    - require:
      - cmd: mise-gpg
    - require_in:
      - pkg: mise
  pkg.installed:
    - refresh: True
  cmd.run:
    - name: mise install
    - cwd: /home/{{ grains['username'] }}
    - runas: {{ grains['username'] }}
    - require:
      - pkg: mise
      - pkg: build-essential

{#- Based on: https://github.com/elifesciences/builder-base-formula/blob/23b0a92f3a83ed625c860189c6902613ff60a534/salt/elife/mise.sls#L1-L13 #}
mise-gpg:
  cmd.run:
    - name: |
        curl --tlsv1.3 --silent --location --fail 'https://mise.jdx.dev/gpg-key.pub' | gpg --dearmor --output {{ keyring }}
    - unless:
      - test -f {{ keyring }}
