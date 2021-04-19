defmodule WkJob.Repo.Migrations.CreateApplicants do
  use Ecto.Migration

  def change do
    execute(
      do_create_list_enum_sql(),
      do_drop_list_enum_sql()
    )

    create table(:applicants, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string)
      add(:description, :string)
      add(:thumb, :string)
      add(:position, :integer, default: 0)
      add(:job_id, :uuid)
      add(:list, :list_type)

      timestamps()
    end

    create(index(:applicants, [:position]))
  end

  @spec do_create_list_enum_sql() :: String.t()
  defp do_create_list_enum_sql(),
    do: "CREATE TYPE list_type AS ENUM ('to_meet', 'in_interview')"

  @spec do_drop_list_enum_sql() :: String.t()
  defp do_drop_list_enum_sql(),
    do: "DROP TYPE IF EXISTS list_type"
end
