{% from 'rust.sls' import cargo_bin with context %}
{%- set grep_alternative = salt['pillar.get']('grep-alternative', 'ripgrep') %}
{%- if grep_alternative == 'ripgrep' and salt['pillar.get']('rust:enabled') %}
ripgrep:
  cmd.run:
    - creates: /home/{{ grains['username'] }}/.cargo/bin/rg
    - name: {{ cargo_bin('cargo') }} +nightly install ripgrep --features simd-accel
    - env:
      - RUSTFLAGS: -C target-cpu=native
    - runas: {{ grains['username'] }}
    - onlyif: {{ cargo_bin('rustup') }} toolchain list | grep -q nightly
    - onchanges:
      - cmd: rust-nightly
    - require:
      - cmd: rust-nightly
{%- elif grep_alternative == 'silversearcher' %}
silversearcher-ag:
  pkg.installed
{%- endif %}
