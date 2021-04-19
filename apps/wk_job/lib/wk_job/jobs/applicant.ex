defmodule WkJob.Jobs.Applicant do
  @moduledoc """
  The module is a applicant to a job
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          name: String.t(),
          description: String.t(),
          thumb: String.t(),
          position: :integer,
          list: :to_meet | :in_interview,
          job_id: Ecto.UUID.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "applicants" do
    field(:name, :string)
    field(:description, :string)
    field(:thumb, :string)
    field(:position, :integer)
    field(:list, Ecto.Enum, values: [:to_meet, :in_interview])
    field(:job_id, Ecto.UUID)

    timestamps()
  end

  @doc false
  @spec changeset(
          t() | Ecto.Schema.t() | Ecto.Changeset.t(t()) | {map(), map()},
          %{binary() => term()} | %{atom() => term()} | :invalid
        ) :: Ecto.Changeset.t(t())
  def changeset(applicant, attrs) do
    applicant
    |> cast(attrs, [:name, :description, :thumb, :position, :list, :job_id])
    |> validate_required([:name, :description, :thumb, :list, :job_id])
  end
end
