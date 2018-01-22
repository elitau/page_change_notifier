defmodule PageChangeNotifier.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias PageChangeNotifier.User

  schema "users" do
    field(:username, :string)
    field(:yo_username, :string)
    field(:telegram_chat_id, :integer)
    field(:email, :string)
    has_many(:search_agents, PageChangeNotifier.SearchAgent)
    timestamps()
  end

  @required_fields [:username]
  @optional_fields [:email, :yo_username, :telegram_chat_id]

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(%User{} = model, attrs \\ %{}) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:username)
  end
end
