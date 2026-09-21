defmodule Theme1.Clock do 
    use Ecto.Schema
    schema "clocks" do 
        field :time, :utc_datetime 
        field :status, :boolean 
        belongs_to :user, Theme1.User 
    end
end