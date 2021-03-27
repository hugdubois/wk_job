# WkJob.Umbrella

To start the Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `yarn install` inside the `apps/wk_job_web/assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check Phoenix deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## ADR

### JavaScript

[yarn](https://yarnpkg.com/) package manager is used rather than [npm](https://www.npmjs.com/).

If you don't have it you could install it via :

```shell
npm install -g yarn
```

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Code quality

Some dependencies that ensure the code quality are installed:

- [ex_check][ex_check]
- [dialyxir][dialyxir]
- [credo][credo]
- [ex_doc][ex_doc]
- [doctor][doctor]

So you can run some mix commands :

```shell
$ mix credo
$ mix dialyzer
$ mix doctor
```

All of these commands are grouped together on one :

```shell
$ mix check
```

[ex_check]: https://hex.pm/packages/ex_check "One task to efficiently run all code analysis & testing tools in an Elixir project"
[dialyxir]: https://hex.pm/packages/dialyxir "Mix tasks to simplify use of Dialyzer in Elixir projects"
[credo]: https://hex.pm/packages/credo "A static code analysis tool with a focus on code consistency and teaching"
[ex_doc]: https://hex.pm/packages/ex_doc "ExDoc is a documentation generation tool for Elixir"
[doctor]: https://hex.pm/packages/doctor "Simple utility to create documentation coverage reports"
