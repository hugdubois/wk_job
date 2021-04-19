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

alias WkJob.Jobs

job_id = "e76c32e7-f88e-47ce-840c-dae0d5d17f28"

1..25
|> Enum.map(fn i ->
  n = i * 4 - 3

  [
    %{
      description: "Producteur de pommes",
      job_id: job_id,
      position: n - 1,
      list: :to_meet,
      name: "Steve Jobs (##{n})",
      thumb: "/images/steve.jpg"
    },
    %{
      description: "Vendeur de portes",
      job_id: job_id,
      position: n,
      list: :to_meet,
      name: "Bill Gates (##{n + 1})",
      thumb: "/images/bill.jpg"
    },
    %{
      description: "Initiateur de liberté",
      job_id: job_id,
      position: n + 1,
      list: :to_meet,
      name: "Richard Stallman (##{n + 2})",
      thumb: "/images/richard.jpg"
    },
    %{
      description: "Entremetteur de faux amis",
      job_id: job_id,
      position: n + 2,
      list: :to_meet,
      name: "Mark Zuckerberg (##{n + 3})",
      thumb: "/images/mark.jpg"
    }
  ]
end)
|> Enum.concat()
|> Enum.each(&Jobs.create_applicant/1)

# 1..1_000
1..10
|> Enum.map(fn job_i ->
  job_id = Ecto.UUID.generate()

  # 1..100
  1..10
  |> Enum.map(fn applicant_i ->
    %{
      description: "Producteur de pommes",
      job_id: job_id,
      position: applicant_i,
      list: Enum.random([:to_meet, :in_interview]),
      name: "Steve Jobs (##{applicant_i})",
      thumb: "/images/steve.jpg"
    }
  end)
  |> Enum.each(&Jobs.create_applicant/1)
end)
