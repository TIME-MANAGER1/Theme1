defmodule Theme1.User do 
    use ecto.Schema

    schema "users" do
        field :username, :string
        field :email, :string
        has_many :clocks, Theme1.Clock 
        has_many :workingtimes, Theme1.Workingtime
    end
end