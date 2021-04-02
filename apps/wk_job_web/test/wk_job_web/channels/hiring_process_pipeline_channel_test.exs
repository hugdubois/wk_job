defmodule WkJobWeb.HiringProcessPipelineChannelTest do
  use WkJobWeb.ChannelCase
  import WkJobWeb.Factory

  setup do
    {:ok, _, socket} =
      WkJobWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(
        WkJobWeb.HiringProcessPipelineChannel,
        "hiring_process_pipeline:" <> new_id()
      )

    %{socket: socket}
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

  # TODO implement it
  # test "get_pipeline replies with status ok and the state of hiring process pipeline a job", %{socket: socket} do
  # ref = push(socket, "get_pipeline", %{"hello" => "there"})
  # assert_reply(ref, :ok, %{"hello" => "there"})
  # end

  test "move_applicant broadcasts to hiring_process_pipeline:<job_id>", %{socket: socket} do
    hiring_process_pipeline = build_hiring_process_pipeline()
    push(socket, "move_applicant", hiring_process_pipeline)
    assert_broadcast("move_applicant", ^hiring_process_pipeline)
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    hiring_process_pipeline = build_hiring_process_pipeline()
    broadcast_from!(socket, "broadcast", hiring_process_pipeline)
    assert_push("broadcast", ^hiring_process_pipeline)
  end
end
