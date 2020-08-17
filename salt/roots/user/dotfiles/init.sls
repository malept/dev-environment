{% from 'user/dotfiles/macros.sls' import bin_file, config_dir, config_file with context %}
{%- set pillar_get = salt['pillar.get'] -%}

{%- if pillar_get('aws:enabled') %}
{{ bin_file('awsify') }}
{{ bin_file('download_rds_slow_query_log') }}
{%- endif %}

{{ bin_file('db_console') }}
{{ bin_file('setup-ssh-agent') }}

{{ config_file('bash_aliases') }}
{{ config_file('bashrc', templated=true) }}
{{ config_file('profile') }}
{{ config_file('sshrc', '.ssh/rc') }}

{{ config_file('ignore') }}

{{ config_file('gitconfig', '.config/git/config', templated=true) }}
{{ config_file('gitignore', '.config/git/ignore') }}

{{ config_file('pip.conf', '.config/pip/pip.conf', templated=true) }}

{%- if pillar_get('profile-sync-daemon:enabled') %}
{{ config_file('psd.conf', '.config/psd/psd.conf', templated=true) }}
{%- endif %}

{%- if pillar_get('nsfv:version') and pillar_get('nsfv:microphone-source') %}
{{ config_file('pulseaudio.conf', '.config/pulse/default.pa', templated=true) }}
{%- endif %}

{{ config_file('psqlrc', '.config/psqlrc') }}
{{ config_dir('.cache/psql') }}

{%- if pillar_get('ruby:enabled') %}
{{ config_file('gemrc') }}
{%- if pillar_get('ruby:manager', 'rvm') == 'rvm' %}
{{ config_file('global.gems', '.rvm/gemsets/global.gems') }}
{%- endif %}
{{ config_file('pryrc') }}
{%- endif %}

{%- if pillar_get('rust:enabled') %}
{{ config_file('cargo_install_config.toml', '.cargo/.install_config.toml', templated=true) }}
{%- endif %}

{{ config_file('starship.toml', '.config/starship.toml', templated=true) }}

{%- if pillar_get('X11:enabled') and pillar_get('X11:Xfce:enabled') %}
{{ config_file('Xmodmap') }}
{{ config_file('synapse-gtkrc', '.config/synapse/gtkrc') }}
{{ config_file('xfce4-screenshooter', '.config/xfce4/xfce4-screenshooter', templated=true) }}
{%- endif %}
