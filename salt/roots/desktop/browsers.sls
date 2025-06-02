{%- set pillar_get = salt['pillar.get'] %}

browsers:
  pkg.installed:
    - pkgs:
{%- if pillar_get('firefox:mp3_support') %}
      - gstreamer1.0-plugins-ugly
{%- endif %}
{%- if grains['os'] == 'Ubuntu' %}
      - chromium-browser
{%- else %}
      - chromium
{%- endif %}
{%- if pillar_get('profile-sync-daemon:enabled') %}
      - profile-sync-daemon
{%- endif %}
{%- if grains['oscodename'] in ['jessie', 'stretch'] %}
    - fromrepo: unstable
{%- endif %}
    - require:
      - pkg: firefox

{%- set mozilla_keyring = "/etc/apt/trusted.gpg.d/packages.mozilla.org.asc" %}
firefox:
  pkgrepo.managed:
    - name: 'deb [signed-by={{ mozilla_keyring }} arch={{ grains['osarch'] | lower }}] https://packages.mozilla.org/apt mozilla main'
    - humanname: Firefox
    - file: /etc/apt/sources.list.d/mozilla.list
    - key_url: https://packages.mozilla.org/apt/repo-signing-key.gpg
    # Disabling apt-key doesn't work specifically for this repo, NO_PUBKEY error despite existence of keyring
    # - signedby: {{ mozilla_keyring }}
    # - aptkey: False
    - require_in:
      - pkg: firefox
    - require:
      - cmd: {{ mozilla_keyring }}
      - file: mozilla-repo-prefs
  pkg.installed:
    - refresh: True

{{ mozilla_keyring }}:
  file.managed:
    - source: https://packages.mozilla.org/apt/repo-signing-key.gpg
    - source_hash: sha256=3ecc63922b7795eb23fdc449ff9396f9114cb3cf186d6f5b53ad4cc3ebfbb11f
  cmd.run:
    - name: |
        gpg --dry-run --quiet --import --import-options import-show {{ mozilla_keyring }} | grep -E [0-9a-fA-F]{40}
        apt-key list
    - success_stdout: 35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3
    - onchanges:
      - file: {{ mozilla_keyring }}

mozilla-repo-prefs:
  file.managed:
    - name: /etc/apt/preferences.d/mozilla
    - source: salt://desktop/files/mozilla.preferences
