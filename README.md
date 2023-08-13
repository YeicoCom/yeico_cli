# Yeico CLI

## Fixme

- Test app with multiple release versions
- Test app with different app name vs folder name

## Usage

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

bin/yeico help # show usage
bin/yeico update # self update asdf package

mix new hello_elixir
bin/yeico build hello_elixir
bin/yeico install kiosk hello_elixir

mix local.hex --force
mix archive.install hex phx_new --force
mix phx.new hello_phoenix --no-ecto
bin/yeico build hello_phoenix
bin/yeico install kiosk hello_phoenix
bin/yeico show kiosk http://localhost:3999/
bin/yeico show kiosk https://google.com
bin/yeico show kiosk https://github.com

mix phx.new --no-dashboard --no-assets --no-ecto --no-gettext --no-html --no-live --no-mailer hello_webapi
bin/yeico build hello_webapi
bin/yeico install kiosk hello_webapi
bin/yeico show kiosk http://localhost:3998/api/
```
