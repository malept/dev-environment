{%- if grains['os'] == 'Debian' %}
postgres:
{%- if grains['oscodename'] == 'jessie' %}
  minor_version: 9.5
{%- else %}
  minor_version: 9.6
{%- endif %}
  users:
    {{ grains['username'] }}:
      superuser: true
  databases:
    {{ grains['username'] }}:
      owner: {{ grains['username'] }}
{%- endif %}
