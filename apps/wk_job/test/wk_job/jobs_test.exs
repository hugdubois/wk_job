defmodule WkJob.JobsTest do
  @moduledoc false
  use WkJob.DataCase

  alias WkJob.Jobs

  describe "hiring_process_pipelines" do
    alias Ecto.UUID
    alias WkJob.Jobs.Applicant
    alias WkJob.Jobs.HiringProcessPipeline

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
      to_meet: [@valid_applicant1_attrs],
      in_interview: [@valid_applicant2_attrs]
    }
    @update_attrs %{
      job_id: @job_id,
      to_meet: [],
      in_interview: [@valid_applicant1_attrs, @valid_applicant2_attrs]
    }
    @invalid_attrs %{job_id: nil, in_interview: nil, to_meet: nil}

    @spec hiring_process_pipeline_fixture(map()) :: HiringProcessPipeline.t()
    def hiring_process_pipeline_fixture(attrs \\ %{}) do
      {:ok, hiring_process_pipeline} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Jobs.create_hiring_process_pipeline()

      hiring_process_pipeline
    end

    test "list_hiring_process_pipelines/0 returns all hiring_process_pipelines" do
      hiring_process_pipeline = hiring_process_pipeline_fixture()
      assert Jobs.list_hiring_process_pipelines() == [hiring_process_pipeline]
    end

    test "get_hiring_process_pipeline!/1 returns the hiring_process_pipeline with given job_id" do
      hiring_process_pipeline = hiring_process_pipeline_fixture()

      assert Jobs.get_hiring_process_pipeline!(hiring_process_pipeline.job_id) ==
               hiring_process_pipeline
    end

    test "get_hiring_process_pipeline/1 returns the hiring_process_pipeline with given job_id" do
      hiring_process_pipeline = hiring_process_pipeline_fixture()

      assert Jobs.get_hiring_process_pipeline(hiring_process_pipeline.job_id) ==
               {:ok, hiring_process_pipeline}

      assert Jobs.get_hiring_process_pipeline("bad_id") ==
               {:error, "Error: invalid UUID job_id bad_id"}
    end

    test "create_hiring_process_pipeline/1 with valid data creates a hiring_process_pipeline" do
      assert {:ok, %HiringProcessPipeline{} = hiring_process_pipeline} =
               Jobs.create_hiring_process_pipeline(@valid_attrs)

      assert hiring_process_pipeline.to_meet == [
               %Applicant{} |> Map.merge(@valid_applicant1_attrs)
             ]

      assert hiring_process_pipeline.in_interview == [
               %Applicant{} |> Map.merge(@valid_applicant2_attrs)
             ]
    end

    test "create_hiring_process_pipeline/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Jobs.create_hiring_process_pipeline(@invalid_attrs)
    end

    test "update_hiring_process_pipeline/2 with valid data updates the hiring_process_pipeline" do
      hiring_process_pipeline = hiring_process_pipeline_fixture()

      assert {:ok, %HiringProcessPipeline{} = hiring_process_pipeline} =
               Jobs.update_hiring_process_pipeline(hiring_process_pipeline, @update_attrs)

      assert hiring_process_pipeline.to_meet == []

      assert hiring_process_pipeline.in_interview == [
               %Applicant{} |> Map.merge(@valid_applicant1_attrs),
               %Applicant{} |> Map.merge(@valid_applicant2_attrs)
             ]
    end

    test "update_hiring_process_pipeline/2 with invalid data returns error changeset" do
      hiring_process_pipeline = hiring_process_pipeline_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Jobs.update_hiring_process_pipeline(hiring_process_pipeline, @invalid_attrs)

      assert hiring_process_pipeline ==
               Jobs.get_hiring_process_pipeline!(hiring_process_pipeline.job_id)
    end

    test "delete_hiring_process_pipeline/1 deletes the hiring_process_pipeline" do
      hiring_process_pipeline = hiring_process_pipeline_fixture()

      assert {:ok, %HiringProcessPipeline{}} =
               Jobs.delete_hiring_process_pipeline(hiring_process_pipeline)

      assert_raise Ecto.NoResultsError, fn ->
        Jobs.get_hiring_process_pipeline!(hiring_process_pipeline.job_id)
      end
    end

    test "change_hiring_process_pipeline/1 returns a hiring_process_pipeline changeset" do
      hiring_process_pipeline = hiring_process_pipeline_fixture()
      assert %Ecto.Changeset{} = Jobs.change_hiring_process_pipeline(hiring_process_pipeline)
    end
  end
end
