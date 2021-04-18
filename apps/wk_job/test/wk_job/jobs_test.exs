defmodule WkJob.JobsTest do
  @moduledoc false
  use WkJob.DataCase

  alias WkJob.Jobs
  alias WkJob.Jobs.{Applicant, HiringProcessPipeline}

  @valid_attrs %{
    description: "some description",
    job_id: "7488a646-e31f-11e4-aace-600308960662",
    name: "some name",
    list: :to_meet,
    position: 42,
    thumb: "some thumb"
  }

  @spec applicant_fixture(map()) :: Applicant.t()
  def applicant_fixture(attrs \\ %{}) do
    {:ok, applicant} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Jobs.create_applicant()

    applicant
  end

  @spec applicant_list_fixture(Ecto.UUID.t(), atom(), pos_integer()) :: [Applicant.t()]
  def applicant_list_fixture(job_id, list, count) do
    1..count
    |> Enum.map(fn i ->
      %{job_id: job_id, name: "applicant #{i}", position: i - 1, list: list}
      |> applicant_fixture()
    end)
  end

  @spec remove_updated_at(Applicant.t() | [Applicant.t()]) :: Applicant.t() | [Applicant.t()]
  def remove_updated_at(%Applicant{} = applicant),
    do: %Applicant{applicant | updated_at: nil}

  def remove_updated_at(applicants),
    do: applicants |> Enum.map(&remove_updated_at/1)

  describe "hiring_process_pipeline" do
    test "get_hiring_process_pipeline/1 returns an error when the job_id is not an UUID" do
      assert Jobs.get_hiring_process_pipeline("bad_id") ==
               {:error, "Error: invalid UUID job_id bad_id"}
    end

    test "get_hiring_process_pipeline/1 returns the applicants lists when applicants exists" do
      job_id = Ecto.UUID.generate()
      initial_to_meet_list = applicant_list_fixture(job_id, :to_meet, 3)
      initial_in_interview_list = applicant_list_fixture(job_id, :in_interview, 3)

      assert {:ok,
              %HiringProcessPipeline{
                to_meet: ^initial_to_meet_list,
                in_interview: ^initial_in_interview_list
              }} = Jobs.get_hiring_process_pipeline(job_id)
    end
  end

  describe "applicants" do
    @update_attrs %{
      description: "some updated description",
      job_id: "7488a646-e31f-11e4-aace-600308960668",
      name: "some updated name",
      list: :in_interview,
      position: 43,
      thumb: "some updated thumb"
    }
    @invalid_attrs %{description: nil, job_id: nil, name: nil, position: nil, thumb: nil}

    test "list_applicants/0 returns all applicants" do
      applicant = applicant_fixture()
      assert Jobs.list_applicants() == [applicant]
    end

    test "get_applicant!/1 returns the applicant with given id" do
      applicant = applicant_fixture()
      assert Jobs.get_applicant!(applicant.id) == applicant
    end

    test "create_applicant/1 with valid data creates a applicant" do
      assert {:ok, %Applicant{} = applicant} = Jobs.create_applicant(@valid_attrs)
      assert applicant.description == "some description"
      assert applicant.job_id == "7488a646-e31f-11e4-aace-600308960662"
      assert applicant.name == "some name"
      assert applicant.position == 42
      assert applicant.thumb == "some thumb"
    end

    test "create_applicant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Jobs.create_applicant(@invalid_attrs)
      assert "can't be blank" in errors_on(changeset).name
      assert "can't be blank" in errors_on(changeset).description
      assert "can't be blank" in errors_on(changeset).thumb
      assert "can't be blank" in errors_on(changeset).list
      assert "can't be blank" in errors_on(changeset).job_id

      assert {:error, %Ecto.Changeset{} = changeset} = Jobs.create_applicant()
      assert "can't be blank" in errors_on(changeset).name
      assert "can't be blank" in errors_on(changeset).description
      assert "can't be blank" in errors_on(changeset).thumb
      assert "can't be blank" in errors_on(changeset).list
      assert "can't be blank" in errors_on(changeset).job_id

      assert {:error, %Ecto.Changeset{} = changeset} =
               %{list: :bad_atom_list}
               |> Enum.into(@valid_attrs)
               |> Jobs.create_applicant()

      assert "is invalid" in errors_on(changeset).list

      assert {:error, %Ecto.Changeset{} = changeset} =
               %{job_id: "bad_id"}
               |> Enum.into(@valid_attrs)
               |> Jobs.create_applicant()

      assert "is invalid" in errors_on(changeset).job_id
    end

    test "update_applicant/2 with valid data updates the applicant" do
      applicant = applicant_fixture()
      assert {:ok, %Applicant{} = applicant} = Jobs.update_applicant(applicant, @update_attrs)
      assert applicant.description == "some updated description"
      assert applicant.job_id == "7488a646-e31f-11e4-aace-600308960668"
      assert applicant.name == "some updated name"
      assert applicant.position == 43
      assert applicant.thumb == "some updated thumb"
    end

    test "update_applicant/2 with invalid data returns error changeset" do
      applicant = applicant_fixture()
      assert {:error, %Ecto.Changeset{}} = Jobs.update_applicant(applicant, @invalid_attrs)
      assert applicant == Jobs.get_applicant!(applicant.id)
    end

    test "delete_applicant/1 deletes the applicant" do
      applicant = applicant_fixture()
      assert {:ok, %Applicant{}} = Jobs.delete_applicant(applicant)
      assert_raise Ecto.NoResultsError, fn -> Jobs.get_applicant!(applicant.id) end
    end

    test "change_applicant/1 returns a applicant changeset" do
      applicant = applicant_fixture()
      assert %Ecto.Changeset{} = Jobs.change_applicant(applicant)
    end

    test "move_applicant_to_list/3 returns an error when no applicant found" do
      Ecto.UUID.generate()
      |> applicant_list_fixture(:to_meet, 3)

      unknown_id = Ecto.UUID.generate()

      expect_error_message =
        "expected at least one result but got none in query:\n\nfrom a0 in WkJob.Jobs.Applicant,\n  where: a0.id == ^\"#{
          unknown_id
        }\"\n"

      assert {:error, %Ecto.NoResultsError{message: ^expect_error_message}} =
               Jobs.move_applicant_to_list(unknown_id, :to_meet, 1)
    end

    test "move_applicant_to_list/3 reorders applicants list when move is in a same list" do
      job_id = Ecto.UUID.generate()
      initial_to_meet_list = applicant_list_fixture(job_id, :to_meet, 3)
      [applicant1, applicant2, applicant3] = initial_to_meet_list

      assert {:ok, %HiringProcessPipeline{to_meet: ^initial_to_meet_list}} =
               Jobs.get_hiring_process_pipeline(job_id)

      # move up applicant3 -> position 1
      assert {:ok, expected_applicant_updated} =
               Jobs.move_applicant_to_list(applicant3.id, :to_meet, 1)

      assert remove_updated_at(expected_applicant_updated) ==
               remove_updated_at(%Applicant{applicant3 | position: 1})

      assert {:ok, %HiringProcessPipeline{to_meet: to_meet}} =
               Jobs.get_hiring_process_pipeline(job_id)

      assert remove_updated_at(to_meet) ==
               remove_updated_at([
                 %Applicant{applicant1 | position: 0},
                 %Applicant{applicant3 | position: 1},
                 %Applicant{applicant2 | position: 2}
               ])

      # move down applicant1 -> position 2
      assert {:ok, expected_applicant_updated} =
               Jobs.move_applicant_to_list(applicant1.id, :to_meet, 2)

      assert remove_updated_at(expected_applicant_updated) ==
               remove_updated_at(%Applicant{applicant1 | position: 2})

      assert {:ok, %HiringProcessPipeline{to_meet: to_meet}} =
               Jobs.get_hiring_process_pipeline(job_id)

      assert remove_updated_at(to_meet) ==
               remove_updated_at([
                 %Applicant{applicant3 | position: 0},
                 %Applicant{applicant2 | position: 1},
                 %Applicant{applicant1 | position: 2}
               ])
    end

    test "move_applicant_to_list/3 reorders applicants lists when the desired list is not the same list" do
      job_id = Ecto.UUID.generate()
      initial_to_meet_list = applicant_list_fixture(job_id, :to_meet, 5)
      [applicant1, applicant2, applicant3, applicant4, applicant5] = initial_to_meet_list

      assert {:ok, %HiringProcessPipeline{to_meet: ^initial_to_meet_list}} =
               Jobs.get_hiring_process_pipeline(job_id)

      # move applicant3 -> position 0 in :in_interview list
      assert {:ok, expected_applicant_updated} =
               Jobs.move_applicant_to_list(applicant3.id, :in_interview, 0)

      assert remove_updated_at(expected_applicant_updated) ==
               remove_updated_at(%Applicant{applicant3 | list: :in_interview, position: 0})

      assert {:ok, %HiringProcessPipeline{to_meet: to_meet, in_interview: in_interview}} =
               Jobs.get_hiring_process_pipeline(job_id)

      assert remove_updated_at(to_meet) ==
               remove_updated_at([
                 %Applicant{applicant1 | position: 0},
                 %Applicant{applicant2 | position: 1},
                 %Applicant{applicant4 | position: 2},
                 %Applicant{applicant5 | position: 3}
               ])

      assert remove_updated_at(in_interview) ==
               remove_updated_at([
                 %Applicant{applicant3 | list: :in_interview, position: 0}
               ])

      # move applicant1 -> position 0 in :in_interview list
      assert {:ok, expected_applicant_updated} =
               Jobs.move_applicant_to_list(applicant1.id, :in_interview, 0)

      assert remove_updated_at(expected_applicant_updated) ==
               remove_updated_at(%Applicant{applicant1 | list: :in_interview, position: 0})

      assert {:ok, %HiringProcessPipeline{to_meet: to_meet, in_interview: in_interview}} =
               Jobs.get_hiring_process_pipeline(job_id)

      assert remove_updated_at(to_meet) ==
               remove_updated_at([
                 %Applicant{applicant2 | position: 0},
                 %Applicant{applicant4 | position: 1},
                 %Applicant{applicant5 | position: 2}
               ])

      assert remove_updated_at(in_interview) ==
               remove_updated_at([
                 %Applicant{applicant1 | list: :in_interview, position: 0},
                 %Applicant{applicant3 | list: :in_interview, position: 1}
               ])

      # move up applicant3 -> position 2 in :to_meet list
      assert {:ok, expected_applicant_updated} =
               Jobs.move_applicant_to_list(applicant3.id, :to_meet, 2)

      assert remove_updated_at(expected_applicant_updated) ==
               remove_updated_at(%Applicant{applicant3 | list: :to_meet, position: 2})

      assert {:ok, %HiringProcessPipeline{to_meet: to_meet, in_interview: in_interview}} =
               Jobs.get_hiring_process_pipeline(job_id)

      assert remove_updated_at(to_meet) ==
               remove_updated_at([
                 %Applicant{applicant2 | position: 0},
                 %Applicant{applicant4 | position: 1},
                 %Applicant{applicant3 | position: 2},
                 %Applicant{applicant5 | position: 3}
               ])

      assert remove_updated_at(in_interview) ==
               remove_updated_at([
                 %Applicant{applicant1 | list: :in_interview, position: 0}
               ])
    end

    test "move_applicant_to_list/3 does nothing when the desired list and the desired postion is not modified" do
      job_id = Ecto.UUID.generate()
      initial_to_meet_list = applicant_list_fixture(job_id, :to_meet, 3)
      [_applicant1, applicant2, _applicant3] = initial_to_meet_list

      assert {:ok, %HiringProcessPipeline{to_meet: ^initial_to_meet_list}} =
               Jobs.get_hiring_process_pipeline(job_id)

      # move up applicant2 -> position 1 (same position)
      assert Jobs.move_applicant_to_list(applicant2.id, :to_meet, 1) ==
               {:ok, applicant2}

      assert {:ok, %HiringProcessPipeline{to_meet: ^initial_to_meet_list}} =
               Jobs.get_hiring_process_pipeline(job_id)
    end
  end
end
