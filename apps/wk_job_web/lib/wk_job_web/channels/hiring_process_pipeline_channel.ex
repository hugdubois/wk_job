defmodule WkJobWeb.HiringProcessPipelineChannel do
  @moduledoc """
  This module is a channel that represents changes in pipeline for a hiring process.

  The channel's topics is `hiring_process_pipeline:<> job_id`.

  The expected `job_id` is a UUID if it is not an unauthorized payload is sent

  The known events are:

  - `move_applicant`

  ## Handler to update the state of the pipeline

  ### Event name

  `move_applicant`

  ### Payload

      %{
        "id" => "applicant UUID",
        "from" => "to_meet | in_interview",
        "to" => "to_meet | in_interview",
        "position" => :int
      }

  ### Example

      %{
        "id" => "e0537c6c-ebb3-4594-9b3b-be6e637c8ed3",
        "from" => "to_meet",
        "to" => "in_interview",
        "position" => 0
      }

  ## Todo

  - the security checks (authorization)

  """
  use WkJobWeb, :channel
  require Logger

  # alias WkJob.Jobs

  @impl true
  def join("hiring_process_pipeline:" <> job_id, payload, socket) do
    if authorized?(payload, job_id) do
      {:ok, assign(socket, :job_id, job_id)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # This handler is a simple ping the paylaoad is returned
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # This handler reprensents the movement of an applicant in the hiring process pipeline
  @impl true
  def handle_in("move_applicant", payload, socket) do
    Logger.debug(socket.assigns)
    Logger.debug(payload)

    # hiring_process_pipeline =
    # socket.assigns.hiring_process_pipeline
    # |> Jobs.update_hiring_process_pipeline(payload)

    # assign(socket, :hiring_process_pipeline, hiring_process_pipeline)
    broadcast(socket, "move_applicant", payload)
    {:noreply, socket}
  end

  # if id is not an UUID authorized? return false
  # TODO: Add authorization logic here as required.
  defp authorized?(_payload, <<_::64, ?-, _::32, ?-, _::32, ?-, _::32, ?-, _::96>> = _job_id),
    do: true

  defp authorized?(_payload, _job_id), do: false
end
