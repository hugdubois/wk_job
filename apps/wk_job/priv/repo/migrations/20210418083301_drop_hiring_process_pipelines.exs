defmodule WkJob.Repo.Migrations.DropHiringProcessPipelines do
  use Ecto.Migration

  def change do
    drop table(:hiring_process_pipelines)
  end
end
