defmodule WkJob.Jobs do
  @moduledoc """
  The Jobs context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias WkJob.Repo

  alias WkJob.Jobs.{Applicant, HiringProcessPipeline}

  @type applicant_response_t() ::
          {:ok, Applicant.t()} | {:error, Ecto.Changeset.t(Applicant.t())}

  @doc """
  Gets a single hiring_process_pipeline by a job_id in parameter

  ## Examples

      iex> get_hiring_process_pipeline("4e6720e5-7c64-4a40-94b9-45e21272df83")
      {:ok, %HiringProcessPipeline{}}

      iex> get_hiring_process_pipeline!("4e6720e5-7c64-4a40-94b9-46e21272df83")
      {:error, reason}

  """
  @spec get_hiring_process_pipeline(Ecto.UUID.t()) ::
          {:ok, HiringProcessPipeline.t()} | {:error, String.t()}
  def get_hiring_process_pipeline(<<_::64, ?-, _::32, ?-, _::32, ?-, _::32, ?-, _::96>> = job_id) do
    query =
      from(Applicant,
        where: [job_id: ^job_id],
        order_by: [asc: :position]
      )

    applicants = Repo.all(query)

    {:ok,
     %HiringProcessPipeline{
       job_id: job_id,
       to_meet: applicants |> Enum.filter(&(&1.list == :to_meet)),
       in_interview: applicants |> Enum.filter(&(&1.list == :in_interview))
     }}
  rescue
    error -> {:error, error}
  end

  def get_hiring_process_pipeline(job_id),
    do: {:error, "Error: invalid UUID job_id #{job_id}"}

  @doc """
  Function to move an applicant in list
  """
  @spec move_applicant_to_list(Ecto.UUID.t(), atom(), integer()) ::
          {:ok, Applicant.t()}
          | {:error, any()}
          | {:error, Multi.name(), any(), %{required(Multi.name()) => any()}}
  def move_applicant_to_list(applicant_id, desired_list, desired_position) do
    applicant_id
    |> get_applicant!()
    |> reorder_applicants_lists(desired_position, desired_list)
    |> case do
      {:ok, %{updated_applicant: updated_applicant}} -> {:ok, updated_applicant}
      {:ok, %Applicant{} = applicant} -> {:ok, applicant}
    end
  rescue
    error -> {:error, error}
  end

  # No move:
  # the current list and the current position are the same
  # of the desired list and the desired position
  defp reorder_applicants_lists(
         %Applicant{list: desired_list, position: desired_position} = applicant,
         desired_position,
         desired_list
       ),
       do: {:ok, applicant}

  # Move an applicant in same list => reorder only
  defp reorder_applicants_lists(
         %Applicant{list: desired_list} = applicant,
         desired_position,
         desired_list
       ),
       do:
         Multi.new()
         |> Multi.update_all(
           :update_positions,
           fn _ -> reorder_applicants_list_before_update(applicant, desired_position) end,
           []
         )
         |> Multi.update(
           :updated_applicant,
           change_applicant(applicant, %{position: desired_position})
         )
         |> Repo.transaction()

  # Move an applicant to another list => reorder and move
  defp reorder_applicants_lists(
         %Applicant{} = applicant,
         desired_position,
         desired_list
       ),
       do:
         Multi.new()
         |> Multi.update(
           :updated_applicant,
           change_applicant(applicant, %{list: desired_list, position: desired_position})
         )
         |> Multi.update_all(
           :update_positions_on_delete,
           fn _ -> reorder_applicants_list_after_delete(applicant) end,
           []
         )
         |> Multi.update_all(
           :update_positions_on_insert,
           fn %{updated_applicant: applicant} ->
             reorder_applicants_list_after_insert(applicant)
           end,
           []
         )
         |> Repo.transaction()

  @doc """
  Returns the list of applicants.

  ## Examples

      iex> list_applicants()
      [%Applicant{}, ...]

  """
  @spec list_applicants :: [Applicant.t()]
  def list_applicants, do: Repo.all(Applicant)

  @doc """
  Gets a single applicant.

  Raises `Ecto.NoResultsError` if the Applicant does not exist.

  ## Examples

      iex> get_applicant!("4e6720e5-7c64-4a40-94b9-45e21272df83")
      %Applicant{}

      iex> get_applicant!("4e6720e5-7c64-4a40-94b9-45e21272df82")
      ** (Ecto.NoResultsError)

  """
  @spec get_applicant!(Ecto.UUID.t()) :: Applicant.t() | no_return()
  def get_applicant!(id), do: Repo.get!(Applicant, id)

  @doc """
  Creates a applicant.

  ## Examples

      iex> create_applicant(%{field: value})
      {:ok, %Applicant{}}

      iex> create_applicant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_applicant(map()) :: applicant_response_t()
  def create_applicant(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:applicant, Applicant.changeset(%Applicant{}, attrs))
    |> Multi.update_all(
      :update_positions_on_insert,
      fn %{applicant: applicant} -> reorder_applicants_list_after_insert(applicant) end,
      []
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{applicant: applicant}} -> {:ok, applicant}
      {:error, :applicant, %Ecto.Changeset{} = changeset_errors, _} -> {:error, changeset_errors}
    end
  end

  @doc """
  Updates a applicant.

  ## Examples

      iex> update_applicant(applicant, %{field: new_value})
      {:ok, %Applicant{}}

      iex> update_applicant(applicant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_applicant(Applicant.t(), map()) :: applicant_response_t()
  def update_applicant(%Applicant{} = applicant, attrs) do
    applicant
    |> change_applicant(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a applicant.

  ## Examples

      iex> delete_applicant(applicant)
      {:ok, %Applicant{}}

      iex> delete_applicant(applicant)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_applicant(Applicant.t()) :: applicant_response_t()
  def delete_applicant(%Applicant{} = applicant) do
    Multi.new()
    |> Multi.delete(:applicant, applicant)
    |> Multi.update_all(
      :update_positions_on_delete,
      fn %{applicant: applicant} -> reorder_applicants_list_after_delete(applicant) end,
      []
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{applicant: applicant}} -> {:ok, applicant}
      {:error, %{applicant: applicant}} -> {:error, applicant}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking applicant changes.

  ## Examples

      iex> change_applicant(applicant)
      %Ecto.Changeset{data: %Applicant{}}

  """
  @spec change_applicant(Applicant.t(), map()) ::
          Ecto.Changeset.t(Applicant.t())
  def change_applicant(%Applicant{} = applicant, attrs \\ %{}),
    do: applicant |> Applicant.changeset(attrs)

  defp reorder_applicants_list_before_update(%Applicant{} = applicant, desired_position)
       when desired_position > applicant.position,
       do:
         from(a in Applicant,
           where:
             a.position > ^applicant.position and
               a.position <= ^desired_position and
               a.list == ^applicant.list and
               a.job_id == ^applicant.job_id,
           update: [inc: [position: -1]]
         )

  defp reorder_applicants_list_before_update(%Applicant{} = applicant, desired_position),
    do:
      from(a in Applicant,
        where:
          a.position >= ^desired_position and
            a.position < ^applicant.position and
            a.list == ^applicant.list and
            a.job_id == ^applicant.job_id,
        update: [inc: [position: 1]]
      )

  defp reorder_applicants_list_after_insert(%Applicant{} = applicant),
    do:
      from(a in Applicant,
        where:
          a.id != ^applicant.id and
            a.position >= ^applicant.position and
            a.list == ^applicant.list and
            a.job_id == ^applicant.job_id,
        update: [inc: [position: 1]]
      )

  defp reorder_applicants_list_after_delete(%Applicant{} = applicant),
    do:
      from(a in Applicant,
        where:
          a.position > ^applicant.position and
            a.list == ^applicant.list and
            a.job_id == ^applicant.job_id,
        update: [inc: [position: -1]]
      )
end
