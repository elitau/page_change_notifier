defmodule PageChangeNotifier.BrowseImmoscout do
  defmodule PageChangeNotifier.TextSollteSichtbarSeinFehler do
    defexception [:message]
  end

  @email Application.get_env(PageChangeNotifier, :immoscout_message_email, "foo@bar.com")
  @password Application.get_env(PageChangeNotifier, :immoscout_message_password, "foo@bar.com")

  use Wallaby.DSL
  import Wallaby.Query, only: [text_field: 1, button: 1, xpath: 1]
  require Logger

  def send_message() do
    boot()

    session()
    |> login()
    |> gehe_zur_anzeige()
    |> oeffne_nachrichtenfenster()
    |> schreibe_nachricht()
    |> verschicke_nachricht()
    |> take_screenshot
  end

  def schreibe_nachricht(session) do
    session
    |> fill_in(
      text_field("contactForm-Message"),
      with: "Hallo, mit wie vielen Bewohnern teilt man sich ein Bad?"
    )
  end

  def verschicke_nachricht(session) do
    session
    |> click(button("Anfrage senden"))
  end

  def oeffne_nachrichtenfenster(session) do
    anbieter_kontaktieren_links =
      Wallaby.Browser.all(session, xpath("(//a[@data-qa='sendButton'])"))

    clickbarer_link = Enum.at(anbieter_kontaktieren_links, 1)
    %Wallaby.Element{parent: session} = Wallaby.Element.click(clickbarer_link)

    session
    |> stelle_sicher("Kontaktanfrage")

    session
  end

  def gehe_zur_anzeige(session) do
    session
    |> visit("https://www.immobilienscout24.de/expose/65993736")
  end

  def boot() do
    {:ok, _} = Application.ensure_all_started(:wallaby)
  end

  def login(session) do
    session
    |> visit("https://sso.immobilienscout24.de/sso/login?appName=is24main")
    |> fill_in(text_field("j_username"), with: @email)
    |> fill_in(text_field("j_password"), with: @password)
    |> click(button("Anmelden"))
  end

  def session() do
    {:ok, session} = Wallaby.start_session()
    session
  end

  def stelle_sicher(session, nachricht) do
    text = Wallaby.Browser.text(session)

    if text =~ nachricht do
      session
    else
      raise PageChangeNotifier.TextSollteSichtbarSeinFehler
    end
  end
end
