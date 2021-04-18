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
      {:error, _} = error -> error
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
       ) do
    Multi.new()
    |> Multi.run(:updated_applicant, fn _, _ ->
      # TODO use a Multi pipe ?
      reorder_applicants_list_after_update(applicant, desired_position)
      update_applicant(applicant, %{position: desired_position})
    end)
    |> Repo.transaction()
  end

  # Move an applicant to another list => reorder and move
  defp reorder_applicants_lists(
         %Applicant{job_id: job_id} = applicant,
         desired_position,
         desired_list
       ) do
    placeholder = %Applicant{applicant | list: desired_list, position: desired_position}

    Multi.new()
    |> Multi.run(:updated_applicant, fn _, _ ->
      # TODO use a Multi pipe ?

      replaced_placeholder =
        from(a in Applicant,
          where:
            a.position == ^desired_position and
              a.list == ^desired_list and
              a.job_id == ^job_id
        )
        |> Repo.one()

      reorder_applicants_list_after_removing(applicant)
      reorder_applicants_list_after_adding(placeholder)

      if replaced_placeholder,
        do: update_applicant(replaced_placeholder, %{position: desired_position + 1})

      update_applicant(applicant, %{list: desired_list, position: desired_position})
    end)
    |> Repo.transaction()
  end

  defp reorder_applicants_list_after_removing(%Applicant{
         job_id: job_id,
         list: list,
         position: position
       }),
       do:
         from(a in Applicant,
           where:
             a.position > ^position and
               a.list == ^list and
               a.job_id == ^job_id,
           update: [inc: [position: -1]]
         )
         |> Repo.update_all([])

  defp reorder_applicants_list_after_adding(%Applicant{
         job_id: job_id,
         list: list,
         position: position
       }),
       do:
         from(a in Applicant,
           where:
             a.position > ^position and
               a.list == ^list and
               a.job_id == ^job_id,
           update: [inc: [position: 1]]
         )
         |> Repo.update_all([])

  defp reorder_applicants_list_after_update(
         %Applicant{job_id: job_id, list: list, position: current_position},
         desired_position
       )
       when desired_position > current_position,
       do:
         from(a in Applicant,
           where:
             a.position > ^current_position and
               a.position <= ^desired_position and
               a.list == ^list and
               a.job_id == ^job_id,
           update: [inc: [position: -1]]
         )
         |> Repo.update_all([])

  defp reorder_applicants_list_after_update(
         %Applicant{job_id: job_id, list: list, position: current_position},
         desired_position
       ),
       do:
         from(a in Applicant,
           where:
             a.position >= ^desired_position and
               a.position < ^current_position and
               a.list == ^list and
               a.job_id == ^job_id,
           update: [inc: [position: 1]]
         )
         |> Repo.update_all([])

  @doc """
  Returns the list of applicants.

  ## Examples

      iex> list_applicants()
      [%Applicant{}, ...]

  """
  @spec list_applicants :: [Applicant.t()]
  def list_applicants do
    Repo.all(Applicant)
  end

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
    # TODO use a Multi pipe and reorder_applicants_list_after_adding

    %Applicant{}
    |> Applicant.changeset(attrs)
    |> Repo.insert()
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
    # TODO use a Multi pipe and reorder_applicants_list_* if position change

    applicant
    |> Applicant.changeset(attrs)
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
    # TODO use a Multi pipe and reorder_applicants_list_after_removing
    Repo.delete(applicant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking applicant changes.

  ## Examples

      iex> change_applicant(applicant)
      %Ecto.Changeset{data: %Applicant{}}

  """
  @spec change_applicant(Applicant.t(), map()) ::
          Ecto.Changeset.t(Applicant.t())
  def change_applicant(%Applicant{} = applicant, attrs \\ %{}) do
    Applicant.changeset(applicant, attrs)
  end
end
