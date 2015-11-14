defmodule PageChangeNotifier.Mailer do
  use Mailgun.Client,
      domain: "https://api.mailgun.net/v3/appf4ce7ee709cd4c2cbef2fb1db76d877c.mailgun.org",
      key: "key-74dcc9e37812eaa1cb65874547c654e9",
      mode: Mix.env,
      test_file_path: "/tmp/mailgun.json"

  def send_new_results_text_email(email_address, results) do
    send_email to: email_address,
               from: "search@ede.li",
               subject: "Es gibt wieder was Neues",
               html: to_html(results)
  end

  def to_html(results) do
    html_start <> html_results(results) <> html_end
    Phoenix.View.render_to_string(PageChangeNotifier.EmailView, "new_results.html", %{results: results})
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
# email = %{to: "duarde.taulie@gmail.com",
#                from: "search@ede.li",
#                subject: "Es gibt wieder was Neues",
#                html: "to_html(results)"}
# attrs = Dict.merge(email, %{
#       to: Dict.fetch!(email, :to),
#       from: Dict.fetch!(email, :from),
#       text: Dict.get(email, :text, ""),
#       html: Dict.get(email, :html, ""),
#       subject: Dict.get(email, :subject, ""),
#     })

# body    = URI.encode_query(Dict.drop(attrs, [:attachments]))
# ctype   = 'application/x-www-form-urlencoded'
# url = "https://api.mailgun.net/v3/appf4ce7ee709cd4c2cbef2fb1db76d877c.mailgun.org/messages"
# url  = String.to_char_list(url)
# key = "key-74dcc9e37812eaa1cb65874547c654e9"
# headers = [{'Authorization', 'Basic ' ++ String.to_char_list(Base.encode64("api:#{key}"))}]
# # body = "body"
# opts = []
# method = :post
# :httpc.request(method, {url, headers, ctype, body}, opts, body_format: :binary)
# :httpc.request(:post, {url, headers}, opts, body_format: :binary)
