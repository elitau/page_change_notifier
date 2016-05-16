defmodule PageChangeNotifier.SearchAgentTest do
  use PageChangeNotifier.ModelCase

  alias PageChangeNotifier.SearchAgent

  @valid_attrs %{url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SearchAgent.changeset(%SearchAgent{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SearchAgent.changeset(%SearchAgent{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "extra long url" do
    long_url = "https://www.immobilienscout24.de/Suche/S-T/Wohnung-Miete/Sachsen/Leipzig/" <>
               "62_1_145_8_10_23_138_146_31_32_143_35_37_57_38_40_47_48_49_52_60_13_64_67" <>
               "_69_63_76_22_20_3_79_80/3,00-5,00/100,00-140,00/EURO-500,00-1300,00/1/128," <>
               "117,118/-/true/-/-/-/-/-/-/-2011/true/-/-/-/1-?enteredFrom=result_list"

    changeset = SearchAgent.changeset(%SearchAgent{}, %{url: long_url})
    assert changeset.valid?
  end
end
