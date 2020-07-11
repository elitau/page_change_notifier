defmodule PageChangeNotifier.Repo.Migrations.AddUniquenessToTelegramChatId do
  use Ecto.Migration

  def change do
    create(unique_index(:users, [:telegram_chat_id]))
  end
end
