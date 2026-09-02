# TourinIt

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

# Development Setup

The easiest way to get set up for local development setup is to use
[asdf](https://asdf-vm.com/guide/getting-started.html).  Once you have `asdf`
installed, you can run:
```
asdf install
```
to install the dependencies found in `.tool-versions`.

Then you can install the packages for this project with:
```
mix deps.get
mix compile
```

To verify that setup is complete, run:
```
mix test
```

# Release process

```
git checkout main
git pull
./bin/version_bump [major|minor|patch]
git push && git push --tags
flyctl deploy
```

[Tourin' It in production](https://tourin-it.fly.dev)

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
