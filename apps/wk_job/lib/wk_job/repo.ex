defmodule WkJob.Repo do
  use Ecto.Repo,
    otp_app: :wk_job,
    adapter: Ecto.Adapters.Postgres
end
