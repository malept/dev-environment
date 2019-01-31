{% from 'user/dotfiles/macros.sls' import bin_file, config_dir, config_file with context %}

{%- if salt['pillar.get']('aws:enabled') %}
{{ bin_file('awsify') }}
{%- endif %}

{{ bin_file('db_console') }}
{{ bin_file('download_rds_slow_query_log') }}

{{ config_file('bash_aliases') }}
{{ config_file('bashrc', templated=true) }}
{{ config_file('profile') }}
{{ config_file('sshrc', '.ssh/rc') }}

{{ config_file('ignore') }}

{{ config_file('gitconfig', '.config/git/config', templated=true) }}
{{ config_file('gitignore', '.config/git/ignore') }}

{{ config_file('pip.conf', '.config/pip/pip.conf', templated=true) }}

{%- if salt['pillar.get']('profile-sync-daemon:enabled') %}
{{ config_file('psd.conf', '.config/psd/psd.conf', templated=true) }}
{%- endif %}

{{ config_file('psqlrc', '.config/psqlrc') }}
{{ config_dir('.cache/psql') }}

{%- if salt['pillar.get']('ruby:enabled') %}
{{ config_file('gemrc') }}
{%- if salt['pillar.get']('ruby:manager', 'rvm') == 'rvm' %}
{{ config_file('global.gems', '.rvm/gemsets/global.gems') }}
{%- endif %}
{{ config_file('pryrc') }}
{%- endif %}

{%- if salt['pillar.get']('X11:enabled') and salt['pillar.get']('X11:Xfce:enabled') %}
{{ config_file('Xmodmap') }}
{{ config_file('synapse-gtkrc', '.config/synapse/gtkrc') }}
{{ config_file('xfce4-screenshooter', '.config/xfce4/xfce4-screenshooter', templated=true) }}
{%- endif %}
