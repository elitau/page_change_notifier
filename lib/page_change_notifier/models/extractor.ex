defmodule PageChangeNotifier.Extractor do
  require Logger

  def parse_html(html) do
    {:ok, html} = Floki.parse_document(html)
    html
  end

  defmodule EbayKleinanzeigen do
    def extract_results(page_html) do
      case page_valid?(page_html) do
        true ->
          page_html
          |> PageChangeNotifier.Extractor.parse_html()
          |> Floki.find("article h2 a")
          |> to_results

        false ->
          Logger.info("Page seems to be invalid: #{page_html}")
          []
      end
    end

    def page_valid?(page_html) do
      page_html =~ ~r/article/
    end

    def to_results(html_elements) do
      html_elements |> Enum.map(fn html_element -> to_result(html_element) end)
    end

    def to_result({_, _, titles} = result) do
      path = Enum.at(result |> Floki.attribute("href"), 0)
      title = Enum.at(titles, 0)
      %PageChangeNotifier.Result{url: prepend_ebay_domain(path), title: title}
    end

    def prepend_ebay_domain(path) do
      "https://www.ebay-kleinanzeigen.de#{path}"
    end
  end

  defmodule Kalaydo do
    @element_css_path "#resultlist li"

    def extract_results(page_html) do
      page_html |> PageChangeNotifier.Extractor.parse_html() |> to_elements |> to_results
    end

    def to_elements(page_html) do
      page_html |> Floki.find(@element_css_path)
    end

    def to_results(html_elements) do
      html_elements |> filter |> Enum.map(fn html_element -> to_result(html_element) end)
    end

    defp filter(html_elements) do
      html_elements |> Enum.filter(fn html_element -> extract_href(html_element) != nil end)
    end

    def to_result(html_element) do
      path = html_element |> extract_href |> to_path
      %PageChangeNotifier.Result{url: path, title: path}
    end

    defp extract_href(html_element) do
      hrefs = html_element |> Floki.find(".resultHeadLine a") |> Floki.attribute("href")
      Enum.at(hrefs, 0)
    end

    defp to_path(element_href) do
      URI.parse(element_href).path |> prepend_domain
    end

    def prepend_domain(path) do
      "http://www.kalaydo.de#{path}"
    end
  end

  defmodule Immoscout do
    @element_css_path "#resultListItems li"

    def extract_results(page_html) do
      page_html |> PageChangeNotifier.Extractor.parse_html() |> to_elements |> to_results
    end

    def to_elements(page_html) do
      page_html |> Floki.find(@element_css_path)
    end

    def to_results(html_elements) do
      html_elements |> filter |> Enum.map(fn html_element -> to_result(html_element) end)
    end

    defp filter(html_elements) do
      html_elements |> Enum.filter(fn html_element -> extract_href(html_element) != nil end)
    end

    def to_result(html_element) do
      path = html_element |> extract_href |> to_path
      %PageChangeNotifier.Result{url: path, title: path}
    end

    defp extract_href(html_element) do
      hrefs = html_element |> Floki.find(".result-list__listing a") |> Floki.attribute("href")
      Enum.at(hrefs, 0)
    end

    defp to_path(element_href) do
      URI.parse(element_href).path |> prepend_domain
    end

    def prepend_domain(path) do
      "http://www.immobilienscout24.de#{path}"
    end
  end

  defmodule Yourimmo do
    @element_css_path ".ci-search-results>div"

    def extract_results(page_html) do
      page_html |> PageChangeNotifier.Extractor.parse_html() |> to_elements |> to_results
    end

    def to_elements(page_html) do
      page_html |> Floki.find(@element_css_path)
    end

    def to_results(html_elements) do
      html_elements |> filter |> Enum.map(fn html_element -> to_result(html_element) end)
    end

    defp filter(html_elements) do
      html_elements |> Enum.filter(&include?/1)
    end

    def to_result(html_element) do
      path = html_element |> extract_href |> to_path
      %PageChangeNotifier.Result{url: path, title: path}
    end

    def include?(html_element) do
      extract_href(html_element) != nil && !includes_immoscout?(html_element)
    end

    defp includes_immoscout?(html_element) do
      html_element
      |> Floki.text()
      |> String.contains?("immobilienscout24")
    end

    defp extract_href(html_element) do
      hrefs = html_element |> Floki.find("a.js-item-title-link") |> Floki.attribute("href")
      Enum.at(hrefs, 0)
    end

    defp to_path(element_href) do
      URI.parse(element_href).path |> prepend_domain
    end

    def prepend_domain(path) do
      "https://www.yourimmo.de" <> path
    end
  end

  # @ebay_schema Regex.compile("")

  def for(page_url) do
    cond do
      matches(~r/ebay/, page_url) ->
        PageChangeNotifier.Extractor.EbayKleinanzeigen

      matches(~r/kalaydo/, page_url) ->
        PageChangeNotifier.Extractor.Kalaydo

      matches(~r/immobilienscout/, page_url) ->
        PageChangeNotifier.Extractor.Immoscout

      matches(~r/yourimmo/, page_url) ->
        PageChangeNotifier.Extractor.Yourimmo

      true ->
        {:no_extractor_defined, page_url}
    end
  end

  def matches(regexp, page_url) do
    Regex.run(regexp, page_url)
  end
end
