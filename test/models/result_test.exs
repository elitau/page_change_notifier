defmodule PageChangeNotifier.ResultTest do
  use PageChangeNotifier.DataCase

  alias PageChangeNotifier.Result

  @search_agent %PageChangeNotifier.SearchAgent{url: "some_url", user_id: 23}
  @valid_attrs %{title: "some content", url: "some content", search_agent: @search_agent}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Result.changeset(%Result{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Result.changeset(%Result{}, @invalid_attrs)
    refute changeset.valid?
  end
end
