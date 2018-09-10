defmodule PageChangeNotifier.Repo.Migrations.CreateSearchAgent do
  use Ecto.Migration

  def change do
    create table(:search_agents) do
      add(:url, :string)
      add(:user_id, references(:users))

      timestamps
    end

    create(index(:search_agents, [:user_id]))
  end
end
