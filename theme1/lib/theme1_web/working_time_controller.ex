defmodule Theme1Web.WorkingTimeController do
  use Theme1Web, :controller

  import Ecto.Query
  alias Theme1.Repo
  alias Theme1.WorkingTime

  def create(conn, %{"userID" => user_id} = params) do
    user_id = String.to_integer(user_id)

    working_time_params = 
      params 
      |> Map.get("workingtime", %{}) # Récupère l'objet workingtime du JSON si présent, ou vide
      |> Map.put("user_id", user_id)   # Injecte le user_id de l'URL

    changeset = WorkingTime.changeset(%WorkingTime{}, working_time_params)

    case Repo.insert(changeset) do
      {:ok, working_time} ->
        conn
        |> put_status(:created)
        |> json(%{data: working_time})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: Ecto.Changeset.traverse_errors(changeset, &translate_errors/1)})
    end
  end

  def index(conn, %{"userID" => user_id} = params) do
    start_date = params["start"]
    end_date = params["end"]

    query = from w in WorkingTime, where: w.user_id == ^user_id


    query = if start_date do
      from w in query, where: w.start >= ^start_date
    else
      query
    end


    query = if end_date do
      from w in query, where: w.end <= ^end_date
    else
      query
    end


    working_times = Repo.all(query)


    json(conn, %{data: working_times})
  end

  def show(conn, %{"userID" => user_id, "id" => id}) do
  
    working_time = Repo.get_by(WorkingTime, id: id, user_id: user_id)

    case working_time do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Working time not found"})

      working_time ->
        json(conn, %{data: working_time})
    end
  end
  def update(conn, %{"id" => id} = params) do

    working_time = Repo.get(WorkingTime, id)

    case working_time do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Working time not found"})

      working_time ->
        working_time_params = Map.get(params, "workingtime", %{})
        
        changeset = WorkingTime.changeset(working_time, working_time_params)

        case Repo.update(changeset) do
          {:ok, updated_working_time} ->
            json(conn, %{data: updated_working_time})

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{errors: Ecto.Changeset.traverse_errors(changeset, &translate_errors/1)})
        end
    end
  end
  def delete(conn, %{"id" => id}) do
    working_time = Repo.get(WorkingTime, id)

    case working_time do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Working time not found"})

      working_time ->

        case Repo.delete(working_time) do
          {:ok, _deleted} ->
            send_resp(conn, :no_content, "")

          {:error, _changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "Could not delete working time"})
        end
    end
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
