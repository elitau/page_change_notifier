defmodule PageChangeNotifier.User do
  use PageChangeNotifier.Web, :model

  schema "users" do
    field :username, :string
    field :yo_username, :string
    field :email, :string
    has_many :search_agents, PageChangeNotifier.SearchAgent
    timestamps
  end

  @required_fields ~w(username)
  @optional_fields ~w(email yo_username)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:username)
  end
end
