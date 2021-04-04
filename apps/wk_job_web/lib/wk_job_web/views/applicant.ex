defmodule WkJobWeb.ApplicantView do
  @moduledoc false
  use WkJobWeb, :view

  @doc """
  Render an applicant schema
  """
  @spec render(String.t(), map()) :: map()
  def render("applicant.json", %{applicant: applicant}) do
    %{
      id: applicant.id,
      name: applicant.name,
      description: applicant.description,
      thumb: applicant.thumb
    }
  end
end
