defmodule PageChangeNotifier.Repo.Migrations.CreateResult do
  use Ecto.Migration

  def change do
    create table(:results) do
      add :url, :string
      add :title, :string

      timestamps
    end

  end
end
