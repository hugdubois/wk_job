defmodule WkJobWeb.HiringProcessPipelineChannelTest do
  use WkJobWeb.ChannelCase

  import WkJobWeb.TestHelpers

  alias Ecto.UUID

  @job_id UUID.generate()

  @valid_payload %{
    id: UUID.generate(),
    from: "to_meet",
    to: "in_interview",
    position: 0
  }

  defp valid_payload,
    do:
      @valid_payload
      |> map_with_string_key()

  setup do
    {:ok, _, socket} =
      WkJobWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(
        WkJobWeb.HiringProcessPipelineChannel,
        "hiring_process_pipeline:" <> @job_id
      )

    %{socket: socket, job_id: @job_id}
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
end
