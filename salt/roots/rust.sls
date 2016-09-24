rustup:
  cmd.run:
    - name: 'curl -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y'
    - runas: {{ grains['username'] }}
    - cwd: /home/{{ grains['username'] }}
    - creates: /home/{{ grains['username'] }}/.cargo/bin/rustup
