{%- set nushell_config_dir = '/home/{}/.config/nushell'.format(grains['username']) %}
{%- set envd_files = ['00-default.nu', '01-path.nu', '02-apps.nu'] %}
{%- set config_file = [nushell_config_dir, 'config.nu'] | join('/') %}
{%- set configd_files = ['00-default.nu', '01-theme.nu', '02-nu-scripts-completions.nu.jinja', '03-apps.nu'] %}

{%- macro nushell_cfg(cfg_type, extra_files) %}
{%- set base_file = [nushell_config_dir, '{}.nu'.format(cfg_type)] | join('/') %}
{%- set targets = [] %}

{%- for file in extra_files %}
{%- if file.endswith('.jinja') %}
{%- set target = file.rsplit('.', 1)[0] %}
{%- else %}
{%- set target = file %}
{%- endif %}
{%- do targets.append(target) %}
{{ nushell_config_dir }}/{{ cfg_type }}.d/{{ target }}:
  file.managed:
    - source: salt://user/dotfiles/files/nushell/{{ cfg_type }}/{{ file }}
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - mode: 644
    - makedirs: True
{%- if file.endswith('.jinja') %}
    - template: jinja
{%- endif %}
    - require_in:
      - file: {{ base_file }}
{%- endfor %}

{{ base_file }}:
  file.managed:
    - user: {{ grains['username'] }}
    - group: {{ grains.get('usergroup', grains['username']) }}
    - mode: 644
    - makedirs: True
    - contents:
      {%- for file in extra_files %}
      - source {{ nushell_config_dir }}/{{ cfg_type }}.d/{{ targets[loop.index0] }}
      {%- endfor %}
{%- endmacro %}

{{ nushell_cfg('env', envd_files) }}
{{ nushell_cfg('config', configd_files) }}

nu_scripts:
  git.latest:
    - name: https://github.com/nushell/nu_scripts.git
    - rev: main
    - target: /home/{{ grains['username'] }}/Code/@nushell/nu_scripts
    - require:
      - pkg: git
    - user: {{ grains['username'] }}
    - require_in:
      - file: {{ config_file }}
