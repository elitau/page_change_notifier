defmodule PageChangeNotifier.Mailer do
  use Mailgun.Client,
      # domain: Application.get_env(:page_change_notifier, :mailgun_domain),
      # key: Application.get_env(:page_change_notifier, :mailgun_key)
      domain: "https://api.mailgun.net/v3/#{System.get_env("MAILGUN_DOMAIN")}",
      key: System.get_env("MAILGUN_API_KEY")
      # mode: Mix.env,
      # test_file_path: "/tmp/mailgun.json"

  def send_new_results_text_email(email_address, results) do
    send_email to: email_address,
               from: "search@ede.li",
               subject: "Es gibt wieder was Neues",
               html: to_html(results)
  end
  # PageChangeNotifier.Mailer.send_new_results_text_email("duarde.taulie@gmail.com", [%{title: "title", url: u}])
  def to_html(results) do
    html_start <> html_results(results) <> html_end
    # Phoenix.View.render_to_string(PageChangeNotifier.EmailView, "new_results.html", %{results: results})
  end

  def html_results(results) do
    Enum.join(Enum.map(results, fn(result) -> html_result(result) end))
  end

  def html_result(result) do
    "<li><a href=\"#{result.url}\">#{result.title}</a></li>"
  end

  def html_start do
    ~s(
      <div class="content">
        <h3>New results</h3>
        <ol>
      )
  end

  def html_end do
    ~s(    </ol>
      </div>
      )
  end
end
