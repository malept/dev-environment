{%- macro venv(venv_name, req_txt_path, python, binary_requirements=False) %}
{%- set venv_dir = '/home/{}/.local/share/virtualenv/{}'.format(grains['username'], venv_name) %}
{{ venv_dir }}:
  virtualenv.managed:
    - user: {{ grains['username'] }}
{%- if python %}
    - python: {{ python }}
{%- endif %}
    - system_site_packages: True
    - requirements: {{ req_txt_path }}
    - require:
      - pkg: python{% if python == 'python3' %}3{% endif %}-packages
{%- if binary_requirements %}
      - pkg: python{% if python == 'python3' %}3{% endif %}-dev
{%- endif %}
{%- for rtype, rname in kwargs %}
      - {{ rtype }}: {{ rname }}
{%- endfor %}
{%- endmacro %}

{%- macro venv2(venv_name, req_txt_path, binary_requirements=False) %}
{{ venv(venv_name, req_txt_path, 'python2', binary_requirements) }}
{%- endmacro %}

{%- macro venv3(venv_name, req_txt_path, binary_requirements=False) %}
{{ venv(venv_name, req_txt_path, 'python3', binary_requirements) }}
{%- endmacro %}

{%- macro venv3_with_binary(venv_name, bin_name, req_txt_path, binary_requirements=False) %}
{{ venv3(venv_name, req_txt_path, binary_requirements, **kwargs) }}
{%- set venv_dir = '/home/{}/.local/share/virtualenv/{}'.format(grains['username'], venv_name) %}

/home/{{ grains['username'] }}/.local/bin/{{ bin_name }}:
  file.symlink:
    - target: {{ venv_dir }}/bin/{{ bin_name }}
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - makedirs: True
    - require:
      - virtualenv: {{ venv_dir }}
{%- endmacro %}
