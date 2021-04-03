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
  to_meet: [
    %{
      description: "Producteur de pommes",
      id: "9540ab55-e9eb-48a7-a3a1-cdec46437641",
      name: "Steve Jobs",
      thumb: "/images/steve.jpg"
    },
    %{
      description: "Vendeur de portes",
      id: "e35a8c24-f4c5-4756-87d8-9024f481dea3",
      name: "Bill Gates",
      thumb: "/images/bill.jpg"
    },
    %{
      description: "Initiateur de liberté",
      id: "4e6720e5-7c64-4a40-94b9-45e21272df83",
      name: "Richard Stallman",
      thumb: "/images/richard.jpg"
    },
    %{
      description: "Entremetteur de faux amis",
      id: "d64c863a-233c-4f3b-8fa6-9fbe2a8bde78",
      name: "Mark Zuckerberg",
      thumb: "/images/mark.jpg"
    }
  ],
  in_interview: []
})
