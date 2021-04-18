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

    # TODO : make list entity then add the relation : belongs_to :list, WkJob.Jobs.List
    field(:list, Ecto.Enum, values: [:to_meet, :in_interview])

    # TODO : make job entity then add the relation : belongs_to :job, WkJob.Jobs.Job
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

    # TODO when list entity is created do :
    # |> foreign_key_constraint(:list_id)
    # TODO when job entity is created do :
    # |> foreign_key_constraint(:job_id)
  end
end
