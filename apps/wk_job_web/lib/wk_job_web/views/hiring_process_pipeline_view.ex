defmodule WkJobWeb.HiringProcessPipelineView do
  @moduledoc false
  use WkJobWeb, :view
  alias WkJobWeb.ApplicantView
  alias WkJobWeb.HiringProcessPipelineView

  @doc """
  Render a list of hiring process pipeline schema
  """
  @spec render(String.t(), map()) :: map()
  def render("index.json", %{hiring_process_pipelines: hiring_process_pipelines}) do
    %{
      data:
        render_many(
          hiring_process_pipelines,
          HiringProcessPipelineView,
          "hiring_process_pipeline.json"
        )
    }
  end

  @doc """
  Render a hiring process pipeline schema wrapper with data atrribute
  """
  def render("show.json", %{hiring_process_pipeline: hiring_process_pipeline}) do
    %{
      data:
        render_one(
          hiring_process_pipeline,
          HiringProcessPipelineView,
          "hiring_process_pipeline.json"
        )
    }
  end

  @doc """
  Render a hiring process pipeline schema
  """
  def render("hiring_process_pipeline.json", %{hiring_process_pipeline: hiring_process_pipeline}) do
    %{
      job_id: hiring_process_pipeline.job_id,
      to_meet:
        render_many(
          hiring_process_pipeline.to_meet,
          ApplicantView,
          "applicant.json"
        ),
      in_interview:
        render_many(
          hiring_process_pipeline.in_interview,
          ApplicantView,
          "applicant.json"
        )
    }
  end
end
