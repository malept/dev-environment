{% from 'rust.sls' import cargo_install with context %}
{%- set grep_alternative = salt['pillar.get']('grep-alternative', 'ripgrep') %}
{%- if grep_alternative == 'ripgrep' and salt['pillar.get']('rust:enabled') %}
{{ cargo_install('ripgrep', binary='rg', toolchain='nightly', env={ 'RUSTFLAGS': '-C target-cpu=native' }, features='simd-accel') }}
{%- elif grep_alternative == 'silversearcher' %}
silversearcher-ag:
  pkg.installed
{%- endif %}
