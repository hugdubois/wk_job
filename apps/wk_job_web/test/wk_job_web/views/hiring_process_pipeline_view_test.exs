defmodule WkJobWeb.HiringProcessPipelineViewTest do
  use WkJobWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View
  import WkJobWeb.TestHelpers

  alias Ecto.UUID
  alias WkJob.Jobs.HiringProcessPipeline

  @job_id UUID.generate()
  @valid_applicant1_attrs %{
    id: UUID.generate(),
    name: "applicant1 name",
    description: "applicant1 description",
    thumb: "/applicant1/avatar/thumb"
  }
  @valid_applicant2_attrs %{
    id: UUID.generate(),
    name: "applicant2 name",
    description: "applicant2 description",
    thumb: "/applicant2/avatar/thumb"
  }
  @hiring_process_pipeline %HiringProcessPipeline{
    job_id: @job_id,
    to_meet: [@valid_applicant1_attrs],
    in_interview: [@valid_applicant2_attrs]
  }

  defp expected_hiring_process_pipeline,
    do:
      @hiring_process_pipeline
      |> map_with_string_key()

  test "renders index.json" do
    assert render_to_string(WkJobWeb.HiringProcessPipelineView, "index.json", %{
             hiring_process_pipelines: [@hiring_process_pipeline]
           }) ==
             %{
               "data" => [expected_hiring_process_pipeline()]
             }
             |> Jason.encode!()
  end

  test "renders show.json" do
    assert render_to_string(WkJobWeb.HiringProcessPipelineView, "show.json", %{
             hiring_process_pipeline: @hiring_process_pipeline
           }) ==
             %{
               "data" => expected_hiring_process_pipeline()
             }
             |> Jason.encode!()
  end

  test "renders hiring_process_pipeline.json" do
    assert render_to_string(WkJobWeb.HiringProcessPipelineView, "hiring_process_pipeline.json", %{
             hiring_process_pipeline: @hiring_process_pipeline
           }) ==
             expected_hiring_process_pipeline() |> Jason.encode!()
  end
end
