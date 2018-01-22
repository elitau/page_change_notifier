defmodule PageChangeNotifier.SearchAgent do
  use Ecto.Schema
  import Ecto.Changeset
  alias PageChangeNotifier.SearchAgent

  schema "search_agents" do
    field(:url, :string)
    belongs_to(:user, PageChangeNotifier.User)
    has_many(:results, PageChangeNotifier.Result)

    timestamps()
  end

  @required_fields [:url]
  @optional_fields [:user_id]

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(%SearchAgent{} = model, attrs \\ %{}) do
    model
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
