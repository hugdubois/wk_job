defmodule WkJobWeb.HiringProcessPipelineChannelTest do
  use WkJobWeb.ChannelCase

  import WkJobWeb.TestHelpers

  alias Ecto.UUID
  alias WkJob.Jobs

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
  @valid_attrs %{
    job_id: @job_id,
    to_meet: [@valid_applicant1_attrs, @valid_applicant2_attrs],
    in_interview: []
  }

  @valid_payload %{
    to_meet: [@valid_applicant2_attrs],
    in_interview: [@valid_applicant1_attrs]
  }

  @spec fixture(atom()) :: HiringProcessPipeline.t()
  def fixture(:hiring_process_pipeline) do
    {:ok, hiring_process_pipeline} = Jobs.create_hiring_process_pipeline(@valid_attrs)
    hiring_process_pipeline
  end

  defp valid_payload,
    do:
      @valid_payload
      |> map_with_string_key()

  setup do
    %{hiring_process_pipeline: hiring_process_pipeline} = create_hiring_process_pipeline()

    {:ok, _, socket} =
      WkJobWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(
        WkJobWeb.HiringProcessPipelineChannel,
        "hiring_process_pipeline:" <> @job_id
      )

    %{socket: socket, hiring_process_pipeline: hiring_process_pipeline}
  end

  test "unauthorized channel if the job id is not an UUID" do
    emsg = "unauthorized"

    assert {:error, %{reason: ^emsg}} =
             WkJobWeb.UserSocket
             |> socket("user_id", %{some: :assign})
             |> subscribe_and_join(
               WkJobWeb.HiringProcessPipelineChannel,
               "hiring_process_pipeline:lobby"
             )
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push(socket, "ping", %{"hello" => "there"})
    assert_reply(ref, :ok, %{"hello" => "there"})
  end

  test "move_applicant broadcasts to hiring_process_pipeline:<job_id>", %{socket: socket} do
    payload = valid_payload()
    push(socket, "move_applicant", payload)
    assert_broadcast("move_applicant", ^payload)
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    payload = valid_payload()
    broadcast_from!(socket, "broadcast", payload)
    assert_push("broadcast", ^payload)
  end

  defp create_hiring_process_pipeline do
    hiring_process_pipeline = fixture(:hiring_process_pipeline)
    %{hiring_process_pipeline: hiring_process_pipeline}
  end
end
