defmodule Theme1.Repo do
  use Ecto.Repo,
    otp_app: :theme1,
    adapter: Ecto.Adapters.Postgres
end
