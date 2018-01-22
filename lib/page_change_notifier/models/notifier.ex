defmodule PageChangeNotifier.Notifier do
  def notify(_, []) do
    # do nothing
  end

  def notify(search_agent, new_results) do
    # send_mail(search_agent.user.email, new_results)
    send_yo(search_agent.user.yo_username, search_agent.url)
    send_telegram_message(search_agent.user.telegram_chat_id, new_results)
  end

  # def send_mail(email, new_results) do
  #   PageChangeNotifier.Mailer.send_new_results_text_email(email, new_results)
  # end

  def send_yo(nil, _) do
    # do nothing
  end

  def send_yo(username, url) do
    PageChangeNotifier.YoApi.send_link(username, url)
  end

  def send_telegram_message(nil, _) do
    # do nothing
  end

  def send_telegram_message(chat_id, new_results) do
    new_results |> Enum.map(fn result -> Nadia.send_message(chat_id, result.url) end)
  end
end
