defmodule PageChangeNotifier.Mailer do
  use Mailgun.Client,
      domain: "https://api.mailgun.net/v3/#{System.get_env("MAILGUN_DOMAIN")}",
      key: System.get_env("MAILGUN_API_KEY"),
      mode: Mix.env,
      test_file_path: "/tmp/mailgun.json"

  def send_new_results_text_email(email_address, results) do
    send_email to: email_address,
               from: "search@ede.li",
               subject: "Es gibt wieder was Neues",
               html: to_html(results)
  end

  def to_html(results) do
    Phoenix.View.render_to_string(PageChangeNotifier.EmailView, "new_results.html", %{results: results})
  end
end
