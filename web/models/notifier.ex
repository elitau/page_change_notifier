defmodule PageChangeNotifier.Notifier do
  def notify(search_agent, results) do
    send_mail(search_agent.user.email, results)
    send_yo(search_agent.user.yo_username, search_agent.url)
  end

  def send_mail(email, results) do
    PageChangeNotifier.Mailer.send_new_results_text_email(email, results)
  end

  def send_yo(nil, url) do
    # do nothing
  end

  def send_yo(username, url) do
    PageChangeNotifier.YoApi.send_link(username, url)
  end

end
