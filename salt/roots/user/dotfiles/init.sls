{% from 'user/dotfiles/macros.sls' import bin_file, config_dir, config_file with context %}
{%- set pillar_get = salt['pillar.get'] -%}

{%- if pillar_get('aws:enabled') %}
{{ bin_file('awsify') }}
{{ bin_file('download_rds_slow_query_log') }}
{%- endif %}

{{ bin_file('db') }}
{{ bin_file('setup-ssh-agent') }}

{%- if pillar_get('github:enabled') %}
{% set gh_clone_dir = '.local/share/gh/extensions/gh-clone' %}
{{ config_dir(gh_clone_dir) }}
{{ config_file('gh/clone/manifest.yml.jinja', [gh_clone_dir, 'manifest.yml'] | join('/'), templated=true) }}
{{ bin_file('gh-clone', srcdir="gh/clone", destdir=gh_clone_dir) }}
{%- endif %}

{{ config_file('bash_aliases', templated=true) }}
{{ config_file('bashrc', templated=true) }}
{{ config_file('profile') }}
{{ config_file('sshrc', '.ssh/rc') }}

{{ config_file('ignore') }}

{{ config_file('gitconfig', '.config/git/config', templated=true) }}
{{ config_file('gitignore', '.config/git/ignore') }}

{{ config_file('pip.conf', '.config/pip/pip.conf', templated=true) }}

{{ config_file('mise.toml.jinja', '.config/mise/config.toml', req_in=[['cmd', 'mise']]) }}
{{ config_file('mise/0000-languages.toml.jinja', '.config/mise/conf.d/0000-languages.toml', templated=true, req_in=[['cmd', 'mise']]) }}
{{ config_file('mise/9999-tools.toml.jinja', '.config/mise/conf.d/9999-tools.toml', templated=true, req_in=[['cmd', 'mise']]) }}

{%- if pillar_get('profile-sync-daemon:enabled') %}
{{ config_file('psd.conf', '.config/psd/psd.conf', templated=true) }}
{%- endif %}

{%- if pillar_get('nsfv:version') and pillar_get('nsfv:microphone-source') %}
{{ config_file('pulseaudio.conf', '.config/pulse/default.pa', templated=true) }}
{%- endif %}

{%- if pillar_get('postgres:enabled') %}
{{ config_file('psqlrc', '.config/psqlrc') }}
{{ config_dir('.cache/psql') }}
{%- endif %}

{%- if pillar_get('ruby:enabled') %}
{{ config_file('gemrc') }}
{{ config_file('pryrc') }}
{%- endif %}

{{ config_file('starship.toml', '.config/starship.toml', templated=true) }}

{%- if pillar_get('X11:enabled') or pillar_get('wayland:enabled') %}
{{ config_file('wezterm.lua', '.config/wezterm/wezterm.lua') }}
{%- endif %}
