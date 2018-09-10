defmodule PageChangeNotifier.Repo.Migrations.MakeUrlLonger do
  use Ecto.Migration

  def change do
    alter table(:search_agents) do
      modify(:url, :string, size: 2000)
    end
  end
end
