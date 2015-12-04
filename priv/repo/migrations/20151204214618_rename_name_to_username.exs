defmodule PageChangeNotifier.Repo.Migrations.RenameNameToUsername do
  use Ecto.Migration

  def change do
    rename table(:users), :name, to: :username
  end
end
