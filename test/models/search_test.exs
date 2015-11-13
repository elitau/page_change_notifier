defmodule PageChangeNotifier.SearchTest do
  use PageChangeNotifier.ModelCase

  alias PageChangeNotifier.Search

  test "fetch html" do
    html = Search.get_page_html("http://ede.li")
    assert html =~ "Eduard"
  end
end
