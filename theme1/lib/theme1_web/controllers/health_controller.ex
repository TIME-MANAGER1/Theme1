defmodule Theme1Web.HealthController do
  use Theme1Web, :controller

  def index(conn, _params) do
    json(conn, %{
      status: "ok",
      app: "theme1",
      message: "API is running"
    })
  end
end
