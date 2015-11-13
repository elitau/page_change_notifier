defmodule PageChangeNotifier.Search do
  def run(page_url) do
    page_url |> get_page_html |> extract_results
  end

  def get_page_html(page_url) do
    PageChangeNotifier.Webpage.get_body(page_url)
  end

  def extract_results(page_html) do
    page_html |> Floki.find("article h2 a") |> to_results
  end

  def to_results(html_elements) do
    html_elements |> Enum.map(fn(html_element) -> to_result(html_element) end)
  end

  def to_result({_, attributes, titles}) do
    path = elem(Enum.at(attributes, 0), 1)
    title = Enum.at(titles, 0)
    %{:url => prepend_ebay_domain(path), :title => title}
  end

  def prepend_ebay_domain(path) do
    "http://www.ebay-kleinanzeigen.de#{path}"
  end
end
