{% from 'rust.sls' import cargo_bin with context %}
{%- set grep_alternative = salt['pillar.get']('grep-alternative', 'ripgrep') %}
{%- if grep_alternative == 'ripgrep' %}
ripgrep:
  cmd.run:
    # --features 'simd-accel' blocked on https://github.com/hsivonen/encoding_rs/issues/23
    - name: {{ cargo_bin('cargo') }} +nightly install ripgrep
    - env:
      - RUSTFLAGS: -C target-cpu=native
    - runas: {{ grains['username'] }}
    - onlyif: {{ cargo_bin('rustup') }} toolchain list | grep -q nightly
    - onchanges:
      - file: rust-nightly
    - require:
      - file: rust-nightly
{%- elif grep_alternative == 'silversearcher' %}
silversearcher-ag:
  pkg.installed
{%- endif %}