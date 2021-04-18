defmodule WkJob.Jobs.HiringProcessPipeline do
  @moduledoc """
  The module is a hiring process pipeline
  """
  alias WkJob.Jobs.Applicant

  @type t :: %__MODULE__{
          job_id: Ecto.UUID.t(),
          to_meet: [Applicant.t()],
          in_interview: [Applicant.t()]
        }
  defstruct job_id: nil,
            to_meet: [],
            in_interview: []
end
