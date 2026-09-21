defmodule Theme1.Workingtime do
    use Ecto.Schema
    schema "workingtimes" do 
        field :start, :utc_datetime 
        field :end, :utc_datetime 
        belongs_to :user, Theme1.User
    end
end