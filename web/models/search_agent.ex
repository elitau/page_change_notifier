defmodule PageChangeNotifier.SearchAgent do
  use PageChangeNotifier.Web, :model

  schema "search_agents" do
    field :url, :string
    belongs_to :user, PageChangeNotifier.User
    has_many :results, PageChangeNotifier.Result

    timestamps
  end

  @required_fields ~w(url)
  @optional_fields ~w(user_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
