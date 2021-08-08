defmodule DefineContinentTest do
  use ExUnit.Case

  test "continent name by id: happy path" do
    for id <- 0..7 do
      assert {:ok, _} = DefineContinent.get_continent_name_by_id(id)
    end
  end

  test "continent name by id: wrong args" do
    assert {:error, :incorrect_continent_id} == DefineContinent.get_continent_name_by_id(10)
    assert {:error, :incorrect_continent_id} == DefineContinent.get_continent_name_by_id("")
  end

  test "continent by coordinates: number args" do
    assert {:ok, 3} == DefineContinent.get_continent_by_coordinates(55, 47.0)
  end

  test "continent by coordinates: binary args" do
    assert {:ok, 0} == DefineContinent.get_continent_by_coordinates("-45", "-150.0")
  end
end
