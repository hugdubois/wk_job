# WkJob.Umbrella

To start the Phoenix server:

  * Install dependencies with `mix deps.get` inside the `root` directory
  * Create and migrate your database with `mix ecto.setup` inside the `apps/wk_job` directory
  * Install Node.js dependencies with `yarn install` inside the `apps/wk_job_web/assets` directory
  * Start Phoenix endpoint with `mix phx.server` inside the `root` directory

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check Phoenix deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Up and Running commands

```shell
mix do deps.get, ecto.create, ecto.migrate, run apps/wk_job/priv/repo/seeds.exs
cd apps/wk_job_web/assets
yarn install
cd -
mix phx.server
```

## Prerequisites

- [PostgreSQL][PostgreSQL]: Tested with version `13.2`
- [Erlang][Erlang]: Tested with version `23.3`
- [Elixir][Elixir]: Tested with version `1.11.3`
- [yarn][yarn]: Tested with version `1.22.10` (note: you can use [npm][npm] instead but the `package-lock.json` file is not versioned)

## Demo

![demo screencast](./demo.gif)

## ADR

### JavaScript

[yarn][yarn] package manager is used rather than [npm][npm].

If you don't have it you could install it via :

```shell
npm install -g yarn
```

## Todo

- [ ] use [styled-components](https://styled-components.com/)
- [ ] make responsive UI
- [ ] add CI/CD [github actions](https://github.com/features/actions) + [circleci](https://circleci.com/)
- [ ] add Dockerfile
- [ ] add integration tests (with [cypres][cypress])?
- [ ] improve tests coverage
- [ ] improve documentation

## Code quality

Commits follow [Conventional Commits](https://www.conventionalcommits.org/) and the workflow is [git-flow](http://danielkummer.github.io/git-flow-cheatsheet/).

Some dependencies that ensure the code quality are installed:

### Elixir side

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

### Javascript side (inside `apps/wk_job_web/assets` directory)

- [eslint][eslint]
- [prettier][prettier]
- [jest][jest]

So you can run some `yarn` commands :

```shell
yarn lint # show eslint errors and warnings (only on JS files)
yarn lint-fix # fix eslint errors and warnings (only on JS files)
yarn prettier # fix prettier formating (on js, json, css, scss and md files)
yarn prettier-check # check prettier formating (on js, json, css, scss and md files)
yarn test # jest unit tests
```

## Learn more

  * Erlang official website: https://www.erlang.org
  * Elixir official website: https://elixir-lang.org
  * Phoenix official website: https://www.phoenixframework.org/
  * Phoenix guides: https://hexdocs.pm/phoenix/overview.html
  * Phoenix docs: https://hexdocs.pm/phoenix
  * Phoenix forum: https://elixirforum.com/c/phoenix-forum
  * Phoenix source: https://github.com/phoenixframework/phoenix
  * React official website: https://reactjs.org/

[ex_check]: https://hex.pm/packages/ex_check "One task to efficiently run all code analysis & testing tools in an Elixir project"
[dialyxir]: https://hex.pm/packages/dialyxir "Mix tasks to simplify use of Dialyzer in Elixir projects"
[credo]: https://hex.pm/packages/credo "A static code analysis tool with a focus on code consistency and teaching"
[ex_doc]: https://hex.pm/packages/ex_doc "ExDoc is a documentation generation tool for Elixir"
[doctor]: https://hex.pm/packages/doctor "Simple utility to create documentation coverage reports"
[eslint]: https://eslint.org/ "Find and fix problems in your JavaScript code"
[prettier]: https://prettier.io/ "Opinionated Code Formatter"
[jest]: https://jestjs.io/ "A delightful JavaScript Testing Framework"
[yarn]: https://yarnpkg.com/ "Safe, stable, reproducible projects"
[npm]: https://www.npmjs.com/ "Build amazing things"
[cypress]: https://www.cypress.io/ "Fast, easy and reliable testing for anything that runs in a browser"
[PostgreSQL]: https://www.postgresql.org/ "The World's Most Advanced Open Source Relational Database"
[Erlang]: https://www.erlang.org/ "Build massively scalable soft real-time systems"
[Elixir]: https://elixir-lang.org/ "A dynamic, functional language for building scalable and maintainable applications"
