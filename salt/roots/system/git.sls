git:
  pkg.installed

{%- if grains['os'] == 'Ubuntu' %}
git-ppa:
  pkgrepo.managed:
    - ppa: git-core/ppa
    - require_in:
      - pkg: git
{%- endif %}
