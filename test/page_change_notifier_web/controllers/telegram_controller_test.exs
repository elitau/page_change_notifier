defmodule PageChangeNotifier.TelegramControllerTest do
  use PageChangeNotifierWeb.ConnCase
  use ExUnit.Case

  setup do
    {:ok, conn: build_conn()}
  end

  test "POST /telegram/webhook", %{conn: conn} do
    params = %{"message" => %{"chat" => %{"id" => "23"}, "text" => "message content"}}

    conn = post(conn, "/telegram/webhook", params)
    assert json_response(conn, 200) == "{}"
  end
end
