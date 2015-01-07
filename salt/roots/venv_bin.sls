{%- macro venv_with_binary(venv_name, bin_name, req_txt_path, python=None) %}
/home/{{ grains['username'] }}/.local/share/virtualenv/{{ venv_name }}:
  virtualenv.managed:
    - user: {{ grains['username'] }}
{%- if python %}
    - python: {{ python }}
{%- endif %}
    - system_site_packages: True
    - requirements: {{ req_txt_path }}
    - require:
      - pkg: python-virtualenv
{%- for rtype, rname in varargs %}
      - {{ rtype }}: {{ rname }}
{%- endfor %}

/home/{{ grains['username'] }}/.local/bin/{{ bin_name }}:
  file.symlink:
    - target: /home/{{ grains['username'] }}/.local/share/virtualenv/{{ venv_name }}/bin/{{ bin_name }}
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - makedirs: True
{%- endmacro %}
