defmodule Theme1.WorkingTime do
    use Ecto.Schema
    import Ecto.Changeset
    @derive {Jason.Encoder, only: [:id, :start, :end, :user_id]}
    schema "workingtimes" do 
        field :start, :utc_datetime 
        field :end, :utc_datetime 
        belongs_to :user, Theme1.User, foreign_key: :user_id
        # timestamps()
    end
    @doc false
    def changeset(workingtime, attrs) do
        workingtime
        |> cast(attrs, [:start, :end, :user_id])
        |> validate_required([:start, :end, :user_id])
        |> foreign_key_constraint(:user_id)
    end
end
