{% from 'user/dotfiles/macros.sls' import bin_file, config_file with context %}

{{ bin_file('awsify') }}
{{ bin_file('blade') }}

{{ config_file('agignore') }}
{{ config_file('bash_aliases') }}
{{ config_file('bashrc', templated=true) }}
{{ config_file('gitconfig', templated=true) }}
{{ config_file('gitignore', '.config/git/ignore') }}
{{ config_file('profile') }}
{{ config_file('gemrc') }}
{{ config_file('irbrc') }}
{{ config_file('pryrc') }}
{{ config_file('synapse-gtkrc', '.config/synapse/gtkrc') }}
{{ config_file('xfce4-screenshooter', '.config/xfce4/xfce4-screenshooter', templated=true) }}
