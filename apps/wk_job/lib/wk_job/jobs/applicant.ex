defmodule WkJob.Jobs.Applicant do
  @moduledoc """
  The module is an applicant to a hiring process pipeline
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias WkJob.Jobs.Applicant

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          name: String.t(),
          description: String.t(),
          thumb: String.t()
        }

  embedded_schema do
    field(:description, :string)
    field(:name, :string)
    field(:thumb, :string)
  end

  @doc false
  @spec changeset(
          t() | Ecto.Schema.t() | Ecto.Changeset.t(t()) | {map(), map()},
          %{binary() => term()} | %{atom() => term()} | :invalid
        ) :: Ecto.Changeset.t(t())
  def changeset(%Applicant{} = applicant, attrs) do
    applicant
    |> cast(attrs, [:id, :name, :description, :thumb])
    |> validate_required([:name, :description, :thumb])
  end
end
