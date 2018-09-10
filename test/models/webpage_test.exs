defmodule PageChangeNotifier.WebpageTest do
  use ExUnit.Case, async: false
  use HTTPoison.Base
  # import Mock

  # test_with_mock "return empty string on failure", HTTPoison,
  #   [:passthrough], [get!: fn(_url) -> :meck.exception(HTTPoison.Error) end] do
  #   assert PageChangeNotifier.Webpage.get_body("http://example.com") == ""
  #
  # end

  # Validation of the mock fails because of the raised exception. I've tried to use the correct
  # exception raising with meck but could not get it to work (see above)
  # test_with_mock "return empty string on failure", HTTPoison,
  #   [:passthrough], [get!: fn(_url) -> raise HTTPoison.Error, message: :timeout end] do
  #   assert PageChangeNotifier.Webpage.get_body("http://example.com") == ""
  #   # # Tests that make the expected call
  #   assert called HTTPoison.get!("http://example.com")
  # end
end
