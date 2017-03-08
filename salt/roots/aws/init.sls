{% from 'venv_bin.sls' import venv_with_binary with context -%}
{{ venv_with_binary('aws', 'aws', 'salt://aws/files/awscli-requirements.txt', python='/usr/bin/python3') }}
