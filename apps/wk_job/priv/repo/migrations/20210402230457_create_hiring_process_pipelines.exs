defmodule WkJob.Repo.Migrations.CreateHiringProcessPipelines do
  use Ecto.Migration

  def change do
    create table(:hiring_process_pipelines, primary_key: false) do
      add(:job_id, :binary_id, primary_key: true)
      add(:to_meet, {:array, :map})
      add(:in_interview, {:array, :map})

      timestamps()
    end
  end
end
