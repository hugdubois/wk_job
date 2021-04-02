defmodule WkJobWeb.Factory do
  @moduledoc """
  Factory module is some helpers to build test case.
  """

  @spec new_id() :: Ecto.UUID.t()
  def new_id,
    do: Ecto.UUID.generate()

  @spec build_applicant() :: map()
  def build_applicant,
    do: %{
      "description" => "An applicant description",
      "id" => new_id(),
      "name" => "Applicant Name",
      "thumb" => "/path/to/avatar_thumb"
    }

  @spec build_hiring_process_pipeline() :: map()
  def build_hiring_process_pipeline,
    do: %{
      "to_meet" => [
        build_applicant(),
        build_applicant(),
        build_applicant()
      ],
      "in_interview" => [
        build_applicant()
      ]
    }

  @spec build(atom()) :: struct()
  def build(model),
    do: build(model, %{})

  @spec build(atom(), [] | map()) :: struct()
  def build(model, params) when is_list(params),
    do:
      model
      |> build(Enum.into(params, %{}))

  def build(model, params) when is_map(params),
    do:
      __MODULE__
      |> apply(:"build_#{model}", [])
      |> Map.merge(params)
end
