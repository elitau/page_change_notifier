defmodule Mix.Tasks.PageChangeNotifier.Notify do
  use Mix.Task
  import Mix.Ecto

  @shortdoc "Searches for new results and notifies user"

  def run(_args) do
    {:ok, _} = ensure_started(PageChangeNotifier.Repo)
    Airbrake.start
    try do
      new_results = PageChangeNotifier.NotifierJob.run
      Mix.shell.info "Found #{length(new_results)} new results"
    rescue
      exception -> Airbrake.report(exception)
      Mix.shell.info "Failed with: #{inspect(exception)}"
    end
  end

  # We can define other functions as needed here.
end
