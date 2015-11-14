defmodule Mix.Tasks.PageChangeNotifier.Notify do
  use Mix.Task
  import Mix.Ecto

  @shortdoc "Searches for new results and notifies user"

  def run(_args) do
    {:ok, _} = ensure_started(PageChangeNotifier.Repo)
    new_results = PageChangeNotifier.NotifierJob.run("http://www.ebay-kleinanzeigen.de/s-50937/fahrrad/k0l18675r5")
    Mix.shell.info "Found #{length(new_results)} new results"
  end

  # We can define other functions as needed here.
end
