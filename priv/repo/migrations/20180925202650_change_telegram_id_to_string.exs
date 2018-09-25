defmodule PageChangeNotifier.Repo.Migrations.ChangeTelegramIdToString do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify(:telegram_chat_id, :string)
    end
  end
end
