{%- macro venv(venv_name, req_txt_path, python=None, binary_requirements=False) %}
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
      - pkg: python-virtualenv
{%- if binary_requirements %}
      - pkg: python-dev
{%- endif %}
{%- for rtype, rname in kwargs %}
      - {{ rtype }}: {{ rname }}
{%- endfor %}
{%- endmacro %}

{%- macro venv_with_binary(venv_name, bin_name, req_txt_path, python=None, binary_requirements=False) %}
{{ venv(venv_name, req_txt_path, python, binary_requirements, **kwargs) }}
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
