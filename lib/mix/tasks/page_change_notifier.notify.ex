defmodule Mix.Tasks.PageChangeNotifier.Notify do
  use Mix.Task
  import Mix.Ecto

  @shortdoc "Searches for new results and notifies user"

  @moduledoc """
    This is where we would put any long form documentation or doctests.
  """

  def run(_args) do
    {:ok, pid} = ensure_started(PageChangeNotifier.Repo)
    new_results = PageChangeNotifier.NotifierJob.run("http://www.ebay-kleinanzeigen.de/s-50937/fahrrad/k0l18675r5")
    Mix.shell.info "Found #{length(new_results)} new results"
  end

  # We can define other functions as needed here.
  @doc """
    Ensures the given repository is started and running.
  """
  # @spec ensure_started(Ecto.Repo.t) :: Ecto.Repo.t | no_return
  # def ensure_started(repo) do
  #   {:ok, _} = Application.ensure_all_started(:ecto)

  #   case repo.start_link do
  #     {:ok, pid} -> {:ok, pid}
  #     {:error, {:already_started, _}} -> {:ok, nil}
  #     {:error, error} ->
  #       Mix.raise "could not start repo #{inspect repo}, error: #{inspect error}"
  #   end
  # end
end
