# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     WkJob.Repo.insert!(%WkJob.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
IO.puts("Adding a hiring process pipeline...")

WkJob.Jobs.create_hiring_process_pipeline(%{
  job_id: "e76c32e7-f88e-47ce-840c-dae0d5d17f28",
  to_meet:
    1..25
    |> Enum.map(fn i ->
      n = i * 4 - 3

      [
        %{
          description: "Producteur de pommes\n(candidat ##{n})",
          id: Ecto.UUID.generate(),
          name: "Steve Jobs",
          thumb: "/images/steve.jpg"
        },
        %{
          description: "Vendeur de portes\n(candidat ##{n + 1})",
          id: Ecto.UUID.generate(),
          name: "Bill Gates",
          thumb: "/images/bill.jpg"
        },
        %{
          description: "Initiateur de liberté\n(candidat ##{n + 2})",
          id: Ecto.UUID.generate(),
          name: "Richard Stallman",
          thumb: "/images/richard.jpg"
        },
        %{
          description: "Entremetteur de faux amis\n(candidat ##{n + 3})",
          id: Ecto.UUID.generate(),
          name: "Mark Zuckerberg",
          thumb: "/images/mark.jpg"
        }
      ]
    end)
    |> Enum.concat(),
  in_interview: []
})
