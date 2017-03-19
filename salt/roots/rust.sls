rustup:
  cmd.run:
    - name: 'curl -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y'
    - runas: {{ grains['username'] }}
    - cwd: /home/{{ grains['username'] }}
    - creates: /home/{{ grains['username'] }}/.cargo/bin/rustup

rustup-bash-completion:
  cmd.run:
    - name: /home/{{ grains['username'] }}/.cargo/bin/rustup completions bash > /etc/bash_completion.d/rustup.bash-completion
    - creates: /etc/bash_completion.d/rustup.bash-completion
    - require:
      - cmd: rustup
