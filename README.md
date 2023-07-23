# yeico_cli

Yeico CLI

```bash
asdf plugin add yeico_cli https://github.com/YeicoDev/yeico_asdf.git
asdf list all yeico_cli
asdf install yeico_cli main
asdf install yeico_cli <commit-or-tag-or-release>
asdf uninstall yeico_cli main
asdf uninstall yeico_cli <commit-or-tag-or-release>
asdf global yeico_cli main
asdf global yeico_cli <commit-or-tag-or-release>
asdf local yeico_cli main
asdf local yeico_cli <commit-or-tag-or-release>
asdf plugin remove yeico_cli

yeico install <ip-or-host> <app-path-or-pwd>
yeico start <ip-or-host> <app-path-or-pwd>
yeico stop <ip-or-host> <app-path-or-pwd>
yeico shell <ip-or-host> <app-path-or-pwd>
yeico log <ip-or-host> <app-path-or-pwd>

mix new hello_elixir
bin/yeico build kiosk hello_elixir
bin/yeico upgrade kiosk hello_elixir

mix local.hex --force
mix archive.install hex phx_new --force
mix phx.new hello_phoenix --no-ecto
bin/yeico build kiosk hello_phoenix
bin/yeico upgrade kiosk hello_phoenix
bin/yeico cog kiosk http://localhost:4000/
bin/yeico cog kiosk https://google.com
bin/yeico cog kiosk https://github.com
```

