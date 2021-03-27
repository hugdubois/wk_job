defmodule WkJob.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :wk_job,
    adapter: Ecto.Adapters.Postgres
end
