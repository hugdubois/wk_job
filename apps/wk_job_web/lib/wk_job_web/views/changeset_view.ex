defmodule WkJobWeb.ChangesetView do
  @moduledoc false
  use WkJobWeb, :view

  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` and
  `WkJobWeb.ErrorHelpers.translate_error/1` for more details.
  """
  @spec translate_errors(Ecto.Changeset.t()) :: %{atom() => [String.t() | map()]}
  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  @spec render(String.t(), map()) :: map()
  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{errors: translate_errors(changeset)}
  end
end
