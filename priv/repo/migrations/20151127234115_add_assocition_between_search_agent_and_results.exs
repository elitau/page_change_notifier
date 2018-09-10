defmodule PageChangeNotifier.Repo.Migrations.AddAssocitionBetweenSearchAgentAndResults do
  use Ecto.Migration

  def change do
    alter table(:results) do
      add(:search_agent_id, references(:search_agents))
    end
  end
end
