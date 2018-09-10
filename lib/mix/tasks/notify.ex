defmodule Mix.Tasks.PageChangeNotifier.Notify do
  use Mix.Task

  @shortdoc "Searches for new results and notifies user"

  def run(_args) do
    Mix.Task.run("app.start")

    new_results = PageChangeNotifier.NotifierJob.run()
    Mix.shell().info("Found #{length(new_results)} new results: #{new_results |> inspect()}")
  end
end
