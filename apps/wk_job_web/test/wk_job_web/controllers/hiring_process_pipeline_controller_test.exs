defmodule WkJobWeb.HiringProcessPipelineControllerTest do
  use WkJobWeb.ConnCase

  alias Ecto.UUID
  alias WkJob.Jobs
  alias WkJob.Jobs.HiringProcessPipeline

  @job_id UUID.generate()
  @valid_applicant1_attrs %{
    id: UUID.generate(),
    name: "applicant1 name",
    description: "applicant1 description",
    thumb: "/applicant1/avatar/thumb",
    position: 0,
    list: :to_meet,
    job_id: @job_id
  }
  @valid_applicant2_attrs %{
    id: UUID.generate(),
    name: "applicant2 name",
    description: "applicant2 description",
    thumb: "/applicant2/avatar/thumb",
    position: 1,
    list: :to_meet,
    job_id: @job_id
  }

  @spec fixture(atom()) :: HiringProcessPipeline.t()
  def fixture(:hiring_process_pipeline) do
    {:ok, _} = Jobs.create_applicant(@valid_applicant1_attrs)
    {:ok, _} = Jobs.create_applicant(@valid_applicant2_attrs)
    {:ok, hiring_process_pipeline} = Jobs.get_hiring_process_pipeline(@job_id)

    hiring_process_pipeline
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "show" do
    setup [:create_hiring_process_pipeline]

    test "hiring_process_pipelines when job_id exists", %{
      conn: conn,
      hiring_process_pipeline: hiring_process_pipeline
    } do
      conn = get(conn, Routes.hiring_process_pipeline_path(conn, :show, @job_id))

      assert json_response(conn, 200) ==
               render_json("show.json", hiring_process_pipeline: hiring_process_pipeline)
    end

    test "404 error when job_id doesn't exist", %{conn: conn} do
      job_id = UUID.generate()
      conn = get(conn, Routes.hiring_process_pipeline_path(conn, :show, job_id))

      assert json_response(conn, 200) ==
               render_json("show.json",
                 hiring_process_pipeline: %{
                   job_id: job_id,
                   to_meet: [],
                   in_interview: []
                 }
               )
    end

    test "404 error when job_id isn't a UUID", %{conn: conn} do
      conn = get(conn, Routes.hiring_process_pipeline_path(conn, :show, "bad_id"))

      assert json_response(conn, 404) == "Not Found"
    end
  end

  defp create_hiring_process_pipeline(_) do
    hiring_process_pipeline = fixture(:hiring_process_pipeline)
    %{hiring_process_pipeline: hiring_process_pipeline}
  end

  defp render_json(template, assigns) do
    assigns = Map.new(assigns)

    WkJobWeb.HiringProcessPipelineView.render(template, assigns)
    |> Jason.encode!()
    |> Jason.decode!()
  end
end
