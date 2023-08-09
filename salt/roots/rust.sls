{%- macro rust_target_triple() -%}
{{ grains['cpuarch'] }}-{% if grains['kernel'] == 'Darwin' %}apple{% else %}unknown{% endif %}-{{ grains['kernel']|lower }}{% if grains['kernel'] == 'Linux' %}-gnu{% endif %}
{%- endmacro %}

{%- macro cargo_bin(bin_name) -%}
/home/{{ grains['username'] }}/.cargo/bin/{{ bin_name }}
{%- endmacro %}

rustup:
  cmd.run:
    - name: 'curl -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y'
    - runas: {{ grains['username'] }}
    - cwd: /home/{{ grains['username'] }}
    - creates: {{ cargo_bin('rustup') }}

rustup-bash-completion:
  cmd.run:
    - name: {{ cargo_bin('rustup') }} completions bash > /etc/bash_completion.d/rustup.bash-completion
    - creates: /etc/bash_completion.d/rustup.bash-completion
    - require:
      - cmd: rustup

{%- macro rust_toolchain(toolchain) %}
rust-{{ toolchain }}:
  file.managed:
    - name: /home/{{ grains['username'] }}/.rustup/update-hashes/{{ toolchain }}-{{ rust_target_triple() }}
    - require:
      - cmd: rust-{{ toolchain }}
  cmd.run:
    - name: {{ cargo_bin('rustup') }} toolchain install {{ toolchain }}
    - runas: {{ grains['username'] }}
    - creates: /home/{{ grains['username'] }}/.rustup/update-hashes/{{ toolchain }}-{{ rust_target_triple() }}
    - require:
      - cmd: rustup
{%- endmacro %}

{%- macro cargo_install(package, binary=None, toolchain='stable', env=None, features=None, requires=None) %}
{%- if binary == None %}
{%- set binary = package %}
{%- endif %}
{{ package }}:
  cmd.run:
    - creates: /home/{{ grains['username'] }}/.cargo/bin/{{ binary }}
    - name: {{ cargo_bin('cargo') }} +{{ toolchain }} install {{ package }}{% if features %} --features {{ features }}{% endif %}
{%- if env %}
    - env:
{%- for key, value in env.items() %}
      - {{ key }}: {{ value }}
{%- endfor %}
{%- endif %}
    - runas: {{ grains['username'] }}
    - onlyif: {{ cargo_bin('rustup') }} toolchain list | grep -q {{ toolchain }}
    - require:
      - cmd: rust-{{ toolchain }}
{%- if requires %}
{%- for rtype, rname in requires %}
      - {{ rtype }}: {{ rname }}
{%- endfor %}
{%- endif %}
{%- endmacro %}

{{ rust_toolchain('stable') }}
{{ rust_toolchain('nightly') }}

{{ cargo_install('cargo-update', 'cargo-install-update') }}
{{ cargo_install('cargo-outdated') }}
