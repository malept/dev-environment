{%- macro venv_with_binary(venv_name, bin_name, req_txt_path, python=None, binary_requirements=False) %}
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
{%- for rtype, rname in varargs %}
      - {{ rtype }}: {{ rname }}
{%- endfor %}

/home/{{ grains['username'] }}/.local/bin/{{ bin_name }}:
  file.symlink:
    - target: {{ venv_dir }}/bin/{{ bin_name }}
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - makedirs: True
    - require:
      - virtualenv: {{ venv_dir }}
{%- if binary_requirements %}
{%- if python and 'python3' in python %}
      - pkg: python3-devel
{%- else %}
      - pkg: python2-devel
{%- endif %}
{%- endif %}

{%- endmacro %}
