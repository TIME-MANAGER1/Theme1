defmodule Theme1Web.UserController do
  use Theme1Web, :controller

  import Ecto.Query

  alias Theme1.Repo
  alias Theme1.User

  def index(conn, params) do
    users =
      User
      |> apply_filters(params)
      |> Repo.all()

    json(conn, Enum.map(users, &user_json/1))
  end

  def create(conn, params) do
    changeset = User.changeset(%User{}, params)

    case Repo.insert(changeset) do
        {:ok, user} ->
            conn
            |> put_status(:created)
            |> json(user_json(user))

        {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{
            errors: errors_from_changeset(changeset)
            })
        end
  end

  def show(conn, %{"userID" => user_id}) do
    case Repo.get(User, user_id) do
        nil ->
            conn
            |> put_status(:not_found)
            |> json(%{error: "User not found"})

        user ->
            json(conn, user_json(user))
    end
  end

  def update(conn, %{"userID" => user_id} = params) do
    case Repo.get(User, user_id) do
        nil ->
            conn
            |> put_status(:not_found)
            |> json(%{error: "User not found"})

        user ->
            changeset = User.changeset(user, params)

        case Repo.update(changeset) do
            {:ok, updated_user} ->
            json(conn, user_json(updated_user))

            {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{
                errors: errors_from_changeset(changeset)
            })
        end
    end
  end

  def delete(conn, %{"userID" => user_id}) do
    case Repo.get(User, user_id) do
        nil ->
            conn
            |> put_status(:not_found)
            |> json(%{error: "User not found"})

        user ->
            case Repo.delete(user) do
                {:ok, _deleted_user} ->
                send_resp(conn, :no_content, "")

                {:error, _changeset} ->
                conn
                |> put_status(:unprocessable_entity)
                |> json(%{error: "Could not delete user"})
            end
    end
  end

  defp apply_filters(query, params) do
    query
    |> filter_by_email(params["email"])
    |> filter_by_username(params["username"])
  end

  defp filter_by_email(query, nil), do: query

  defp filter_by_email(query, email) do
    where(query, [user], user.email == ^email)
  end

  defp filter_by_username(query, nil), do: query

  defp filter_by_username(query, username) do
    where(query, [user], user.username == ^username)
  end

  defp user_json(user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email
    }
  end

  defp errors_from_changeset(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, _opts} ->
        message
    end)
  end

end