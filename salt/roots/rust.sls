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
rust-nightly:
  file.managed:
    - name: /home/{{ grains['username'] }}/.rustup/update-hashes/nightly-{{ rust_target_triple() }}
    - require:
      - cmd: rust-nightly
  cmd.run:
    - name: {{ cargo_bin('rustup') }} toolchain install nightly
    - runas: {{ grains['username'] }}
    - creates: /home/{{ grains['username'] }}/.rustup/update-hashes/nightly-{{ rust_target_triple() }}
    - require:
      - cmd: rustup
