defmodule Theme1Web.ClockController do
    use Theme1Web, :controller

    import Ecto.Query
    alias Theme1.Repo

  def index(conn, %{"userID" => user_id}) do
    user_id = String.to_integer(user_id)

    clocks =
      Theme1.Clock
      |> where([a_line_of_clock_table], a_line_of_clock_table.user_id == ^user_id)
      |> Repo.all()

    json(conn, clocks)
  end

def create(conn, params) do
    user_id = String.to_integer(params["userID"])

    attrs = %{
      "time" => params["time"],
      "status" => params["status"],
      "user_id" => user_id
    }

    changeset = Theme1.Clock.changeset(%Theme1.Clock{}, attrs)

    case Repo.insert(changeset) do
      {:ok, clock} ->
        json(conn, clock)

      {:error, changeset} ->
        errors =
          Ecto.Changeset.traverse_errors(changeset, fn {message, _opts} ->
            message
          end)

        json(conn, %{errors: errors})
    end
  end
end