defmodule WkJob.Jobs.HiringProcessPipeline do
  @moduledoc """
  The module is a hiring process pipeline
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias WkJob.Jobs.Applicant

  @type t :: %__MODULE__{
          job_id: Ecto.UUID.t(),
          to_meet: [Applicant.t()],
          in_interview: [Applicant.t()],
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }
  @primary_key {:job_id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "hiring_process_pipelines" do
    embeds_many(:in_interview, Applicant, on_replace: :delete)
    embeds_many(:to_meet, Applicant, on_replace: :delete)

    timestamps()
  end

  @doc false
  @spec changeset(
          t() | Ecto.Schema.t() | Ecto.Changeset.t(t()) | {map(), map()},
          %{binary() => term()} | %{atom() => term()} | :invalid
        ) :: Ecto.Changeset.t(t())
  def changeset(hiring_process_pipeline, attrs) do
    hiring_process_pipeline
    |> cast(attrs, [:job_id])
    |> cast_embed(:to_meet, with: &Applicant.changeset/2)
    |> cast_embed(:in_interview, with: &Applicant.changeset/2)
    |> validate_required([:job_id, :to_meet, :in_interview])
  end
end
