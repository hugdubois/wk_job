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
        "in_interview" => [
          %{
            "description" => "applicant description",
            "id" => "applicant UUID""
            "name" => "applicant name",
            "thumb" => "/path/to/avatar/image"
          },
          ...
        "to_meet" => [
          %{
            "description" => "applicant description",
            "id" => "applicant UUID""
            "name" => "applicant name",
            "thumb" => "/path/to/avatar/image"
          },
          ...
        ]
      }


  ### Example

      %{
        "in_interview" => [
          %{
            "description" => "Initiateur de liberté",
            "id" => "4e6720e5-7c64-4a40-94b9-45e21272df83",
            "name" => "Richard Stallman",
            "thumb" => "/images/richard.jpg"
          },
          %{
            "description" => "Vendeur de portes",
            "id" => "e35a8c24-f4c5-4756-87d8-9024f481dea3",
            "name" => "Bill Gates",
            "thumb" => "/images/bill.jpg"
          }
        ],
        "to_meet" => [
          %{
            "description" => "Producteur de pommes",
            "id" => "9540ab55-e9eb-48a7-a3a1-cdec46437641",
            "name" => "Steve Jobs",
            "thumb" => "/images/steve.jpg"
          },
          %{
            "description" => "Entremetteur de faux amis",
            "id" => "d64c863a-233c-4f3b-8fa6-9fbe2a8bde78",
            "name" => "Mark Zuckerberg",
            "thumb" => "/images/mark.jpg"
          }
        ]
      }

  ## Todo

  - the persistence of the state
  - the security checks (authorization)

  """
  use WkJobWeb, :channel

  @impl true
  def join("hiring_process_pipeline:" <> job_id, payload, socket) do
    if authorized?(payload, job_id) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # This handler is a simple ping the paylaoad is returned
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # TODO: implement it
  # @impl true
  # def handle_in("get_pipeline", payload, socket) do
  # {:reply, {:ok, payload}, socket}
  # end

  # This handler reprensents the movement of an applicant in the hiring process pipeline
  # TODO: the persistence of the state
  @impl true
  def handle_in("move_applicant", payload, socket) do
    broadcast(socket, "move_applicant", payload)
    {:noreply, socket}
  end

  # if id is not an UUID authorized? return false
  # TODO: Add authorization logic here as required.
  defp authorized?(_payload, <<_::64, ?-, _::32, ?-, _::32, ?-, _::32, ?-, _::96>> = _job_id),
    do: true

  defp authorized?(_payload, _job_id), do: false
end
