defmodule WkJobWeb.ApplicantView do
  @moduledoc false
  use WkJobWeb, :view
  alias WkJobWeb.ApplicantView

  @doc """
  Render an applicant schema
  """
  @spec render(String.t(), map()) :: map()
  def render("index.json", %{applicants: applicants}) do
    %{data: render_many(applicants, ApplicantView, "applicant.json")}
  end

  def render("show.json", %{applicant: applicant}) do
    %{data: render_one(applicant, ApplicantView, "applicant.json")}
  end

  def render("applicant.json", %{applicant: applicant}) do
    %{
      id: applicant.id,
      name: applicant.name,
      description: applicant.description,
      thumb: applicant.thumb
    }
  end
end
