defmodule WkJobWeb.HiringProcessPipelineController do
  @moduledoc """
  This module is the controller to manage hiring process pipeline
  """
  use WkJobWeb, :controller
  require Logger

  alias WkJob.Jobs

  action_fallback(WkJobWeb.FallbackController)

  @doc """
  Show a hiring process pipeline
  """
  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t() | {:error, atom()}
  def show(conn, %{"job_id" => job_id}) do
    case Jobs.get_hiring_process_pipeline(job_id) do
      {:ok, hiring_process_pipeline} ->
        render(conn, "show.json", hiring_process_pipeline: hiring_process_pipeline)

      {:error, "Error: can't find hiring process pipeline with job_id " <> ^job_id} ->
        {:error, :not_found}

      {:error, "Error: invalid UUID job_id " <> ^job_id} ->
        {:error, :not_found}

      {:error, error} ->
        Logger.error(
          "Error: an error occurred when Jobs.get_hiring_process_pipeline(#{job_id}) - #{
            inspect(error)
          }"
        )

        {:error, :internal_server_error}
    end
  end
end
