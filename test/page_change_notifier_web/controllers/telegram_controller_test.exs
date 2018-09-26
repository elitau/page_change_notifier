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

  test "POST /telegram/webhook with list option", %{conn: conn} do
    params = %{
      "message" => %{
        "chat" => %{"first_name" => "Ede", "id" => "66456154", "type" => "private"},
        "date" => 1_537_908_315,
        "from" => %{
          "first_name" => "Ede",
          "id" => "66456154",
          "is_bot" => false,
          "language_code" => "en-DE"
        },
        "message_id" => 9258,
        "text" => "list"
      },
      "update_id" => 999_590_595
    }

    conn = post(conn, "/telegram/webhook", params)
    assert json_response(conn, 200) == "{}"
  end
end
