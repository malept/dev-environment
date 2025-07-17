mise activate nu | save --force ~/.cache/mise.nu
mkdir ~/.cache/zoxide ~/.cache/starship
mise exec -- zoxide init nushell | save --force ~/.cache/zoxide/init.nu
mise exec -- starship init nu | save --force ~/.cache/starship/init.nu
