defmodule WkJobWeb.TestHelpers do
  @moduledoc """
  Some test helper functions
  """

  @doc """
  Take a map with atom keys amd return a map with string keys

  ## Examples

      iex> %{a: "aaa", b: %{c: "ccc"}, d: [%{e: 42}, %{f: ["a", "b", 42]}]}
      ...> |> WkJobWeb.TestHelpers.map_with_string_key
      %{
        "a" => "aaa",
        "b" => %{"c" => "ccc"},
        "d" => [%{"e" => 42}, %{"f" => ["a", "b", 42]}]
      }

      iex> %{
      ...>   data: %WkJob.Jobs.HiringProcessPipeline{
      ...>     job_id: "be62d8a2-d8af-4baf-b76e-b3345874195f",
      ...>     to_meet: [%WkJob.Jobs.Applicant{name: "name", description: "description", thumb: "thumb"}],
      ...>     in_interview: []
      ...>   }
      ...> }
      ...> |> WkJobWeb.TestHelpers.map_with_string_key()
      %{
        "data" => %{
          "job_id" => "be62d8a2-d8af-4baf-b76e-b3345874195f",
          "to_meet" => [
            %{
              "id" => nil,
              "description" => "description",
              "name" => "name",
              "thumb" => "thumb",
              "inserted_at" => nil,
              "job_id" => nil,
              "list" => nil,
              "position" => nil,
              "updated_at" => nil
            }
          ],
          "in_interview" => []
        }
      }
  """
  @spec map_with_string_key(map()) :: map()
  def map_with_string_key(%{__meta__: %{__struct__: _}} = schema) when is_map(schema),
    do: schema |> Map.delete(:__meta__) |> map_with_string_key()

  %WkJob.Jobs.HiringProcessPipeline{
    job_id: "be62d8a2-d8af-4baf-b76e-b3345874195f",
    to_meet: [
      %WkJob.Jobs.Applicant{
        name: "name",
        description: "description",
        thumb: "thumb"
      }
    ],
    in_interview: []
  }

  def map_with_string_key(%{__struct__: _} = struct) when is_map(struct),
    do: struct |> Map.delete(:__struct__) |> map_with_string_key()

  def map_with_string_key(map),
    do: for({key, val} <- map, into: %{}, do: {Atom.to_string(key), cast(val)})

  defp cast([h | t] = value) when is_list(value),
    do: [cast(h)] ++ cast(t)

  defp cast([]), do: []

  defp cast(value) when is_map(value),
    do: value |> map_with_string_key

  defp cast(value), do: value
end
