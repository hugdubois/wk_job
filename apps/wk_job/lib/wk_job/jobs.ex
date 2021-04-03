defmodule WkJob.Jobs do
  @moduledoc """
  The Jobs context.
  """

  import Ecto.Query, warn: false
  alias WkJob.Repo

  alias WkJob.Jobs.HiringProcessPipeline

  @type response_t() ::
          {:ok, HiringProcessPipeline.t()} | {:error, Ecto.Changeset.t(HiringProcessPipeline.t())}

  @doc """
  Returns the list of hiring_process_pipelines.

  ## Examples

      iex> list_hiring_process_pipelines()
      [%HiringProcessPipeline{}, ...]

  """
  @spec list_hiring_process_pipelines :: [HiringProcessPipeline.t()]
  def list_hiring_process_pipelines do
    Repo.all(HiringProcessPipeline)
  end

  @doc """
  Gets a single hiring_process_pipeline.

  Raises `Ecto.NoResultsError` if the Hiring process pipeline does not exist.

  ## Examples

      iex> get_hiring_process_pipeline!("4e6720e5-7c64-4a40-94b9-45e21272df83")
      %HiringProcessPipeline{}

      iex> get_hiring_process_pipeline!("4e6720e5-7c64-4a40-94b9-46e21272df83")
      ** (Ecto.NoResultsError)

  """
  @spec get_hiring_process_pipeline!(Ecto.UUID.t()) :: HiringProcessPipeline.t() | no_return()
  def get_hiring_process_pipeline!(job_id), do: Repo.get!(HiringProcessPipeline, job_id)

  @doc """
  Gets a single hiring_process_pipeline.

  ## Examples

      iex> get_hiring_process_pipeline("4e6720e5-7c64-4a40-94b9-45e21272df83")
      {:ok, %HiringProcessPipeline{}}

      iex> get_hiring_process_pipeline!("4e6720e5-7c64-4a40-94b9-46e21272df83")
      {:error, reason}

  """
  @spec get_hiring_process_pipeline(Ecto.UUID.t()) :: response_t() | {:error, String.t()}
  def get_hiring_process_pipeline(<<_::64, ?-, _::32, ?-, _::32, ?-, _::32, ?-, _::96>> = job_id) do
    case(Repo.get(HiringProcessPipeline, job_id)) do
      nil -> {:error, "Error: can't find hiring process pipeline with job_id #{job_id}"}
      pipeline -> {:ok, pipeline}
    end
  rescue
    error -> {:error, error}
  end

  def get_hiring_process_pipeline(job_id),
    do: {:error, "Error: invalid UUID job_id #{job_id}"}

  @doc """
  Creates a hiring_process_pipeline.

  ## Examples

      iex> create_hiring_process_pipeline(%{field: value})
      {:ok, %HiringProcessPipeline{}}

      iex> create_hiring_process_pipeline(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_hiring_process_pipeline(map()) :: response_t()
  def create_hiring_process_pipeline(attrs \\ %{}) do
    %HiringProcessPipeline{}
    |> HiringProcessPipeline.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a hiring_process_pipeline.

  ## Examples

      iex> update_hiring_process_pipeline(hiring_process_pipeline, %{field: new_value})
      {:ok, %HiringProcessPipeline{}}

      iex> update_hiring_process_pipeline(hiring_process_pipeline, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_hiring_process_pipeline(HiringProcessPipeline.t(), map()) :: response_t()
  def update_hiring_process_pipeline(%HiringProcessPipeline{} = hiring_process_pipeline, attrs) do
    hiring_process_pipeline
    |> HiringProcessPipeline.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a hiring_process_pipeline.

  ## Examples

      iex> delete_hiring_process_pipeline(hiring_process_pipeline)
      {:ok, %HiringProcessPipeline{}}

      iex> delete_hiring_process_pipeline(hiring_process_pipeline)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_hiring_process_pipeline(HiringProcessPipeline.t()) :: response_t()
  def delete_hiring_process_pipeline(%HiringProcessPipeline{} = hiring_process_pipeline) do
    Repo.delete(hiring_process_pipeline)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking hiring_process_pipeline changes.

  ## Examples

      iex> change_hiring_process_pipeline(hiring_process_pipeline)
      %Ecto.Changeset{data: %HiringProcessPipeline{}}

  """
  @spec change_hiring_process_pipeline(HiringProcessPipeline.t(), map()) ::
          Ecto.Changeset.t(HiringProcessPipeline.t())
  def change_hiring_process_pipeline(
        %HiringProcessPipeline{} = hiring_process_pipeline,
        attrs \\ %{}
      ) do
    HiringProcessPipeline.changeset(hiring_process_pipeline, attrs)
  end
end
