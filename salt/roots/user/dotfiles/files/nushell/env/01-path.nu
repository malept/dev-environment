$env.PATH = ($env.PATH | split row (char esep) | prepend [
  '~/.local/bin',
  '~/.cargo/bin',
])
