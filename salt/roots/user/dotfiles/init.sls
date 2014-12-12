{% from 'user/dotfiles/macros.sls' import bin_file, config_file with context %}

{%- if salt['pillar.get']('aws:enabled') %}
{{ bin_file('awsify') }}
{%- endif %}
{%- if salt['pillar.get']('chef:enabled') %}
{{ bin_file('blade') }}
{%- endif %}

{{ bin_file('db_console') }}

{{ config_file('bash_aliases') }}
{{ config_file('bashrc', templated=true) }}
{{ config_file('profile') }}

{{ config_file('agignore') }}

{{ config_file('gitconfig', templated=true) }}
{{ config_file('gitignore', '.config/git/ignore') }}

{%- if salt['pillar.get']('ruby:enabled') %}
{{ config_file('gemrc') }}
{{ config_file('irbrc') }}
{{ config_file('pryrc') }}
{%- endif %}

{%- if salt['pillar.get']('X11:enabled') %}
{{ config_file('synapse-gtkrc', '.config/synapse/gtkrc') }}
{{ config_file('tmux.conf', '.config/tmux/tmux.conf') }}
{{ config_file('xfce4-screenshooter', '.config/xfce4/xfce4-screenshooter', templated=true) }}
{%- endif %}
