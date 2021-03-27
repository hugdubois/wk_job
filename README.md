# WkJob.Umbrella


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
