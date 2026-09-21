defmodule Theme1.Repo.Migrations.CreateWorkingtime do
  use Ecto.Migration

  def change do
    create table (:workingtime) do
    add :start, :utc_datetime, null: false
    add :end, :utc_datetime, null: false
    add :user_id, references(:users), null: false
    end  
  end
end
