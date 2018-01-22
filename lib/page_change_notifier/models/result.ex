defmodule PageChangeNotifier.Result do
  use Ecto.Schema
  import Ecto.Changeset

  schema "results" do
    field(:url, :string)
    field(:title, :string)
    belongs_to(:search_agent, PageChangeNotifier.SearchAgent)

    timestamps()
  end

  @required_fields [:url]
  @optional_fields [:title]

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(%PageChangeNotifier.Result{} = model, attrs \\ %{}) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
