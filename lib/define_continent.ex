defmodule DefineContinent do
  @moduledoc false

  # Polygons were taken here: https://stackoverflow.com/a/25075832

  @n_am {1, %Geo.Polygon{coordinates: [[
    {90, -168.75}, {90, -10}, {78.13, -10}, {57.5, -37.5}, {15, -30}, {15, -75}, {1.25, -82.5}, {1.25, -105}, {51, -180}, {60, -180}, {60, -168.75}
  ]]}}

  @s_am {2, %Geo.Polygon{coordinates: [[
    {1.25, -105}, {1.25, -82.5}, {15, -75}, {15, -30}, {-60, -30}, {-60, -105}
  ]]}}

  @eu {3, %Geo.Polygon{coordinates: [[
    {90, -10}, {90, 77.5}, {42.5, 48.8}, {42.5, 30}, {40.79, 28.81}, {41, 29}, {40.55, 27.31}, {40.4, 26.75}, {40.05, 26.36}, {39.17, 25.19}, {35.46, 27.91}, {33, 27.5}, {38, 10}, {35.42, -10}, {28.25, -13}, {15, -30}, {57.5, -37.5}, {78.13, -10}
  ]]}}

  @afr {4, %Geo.Polygon{coordinates: [[
    {15, -30}, {28.25, -13}, {35.42, -10}, {38, 10}, {33, 27.5}, {31.74, 34.58}, {29.54, 34.92}, {27.78, 34.46}, {11.3, 44.3}, {12.5, 52}, {-60, 75}, {-60, -30}
  ]]}}

  @aus {5, %Geo.Polygon{coordinates: [[
    {-11.88, 110}, {-10.27, 140}, {-10, 145}, {-30, 161.25}, {-52.5, 142.5}, {-31.88, 110}
  ]]}}

  @asi {6, %Geo.Polygon{coordinates: [[
    {90, 77.5}, {42.5, 48.8}, {42.5, 30}, {40.79, 28.81}, {41, 29}, {40.55, 27.31}, {40.4, 26.75}, {40.05, 26.36}, {39.17, 25.19}, {35.46, 27.91}, {33, 27.5}, {31.74, 34.58}, {29.54, 34.92}, {27.78, 34.46}, {11.3, 44.3}, {12.5, 52}, {-60, 75}, {-60, 110}, {-31.88, 110}, {-11.88, 110}, {-10.27, 140}, {33.13, 140}, {51, 166.6}, {60, 180}, {90, 180}
  ]]}}

  @ant {7, %Geo.Polygon{coordinates: [[
    {-60, -180}, {-60, 180}, {-90, 180}, {-90, -180}
  ]]}}

  @type latitude :: number() | String.t()
  @type longitude :: number() | String.t()
  @type continent_id :: integer()
  @type continent_name :: String.t()

  @spec get_continent_name_by_id(id :: continent_id()) :: {:ok, continent_name()} | {:error, :incorrect_continent_id}
  def get_continent_name_by_id(0), do: {:ok, "OTHER_WORLD"}
  def get_continent_name_by_id(1), do: {:ok, "NORTH_AMERICA"}
  def get_continent_name_by_id(2), do: {:ok, "SOUTH_AMERICA"}
  def get_continent_name_by_id(3), do: {:ok, "EUROPE"}
  def get_continent_name_by_id(4), do: {:ok, "AFRICA"}
  def get_continent_name_by_id(5), do: {:ok, "AUSTRALIA"}
  def get_continent_name_by_id(6), do: {:ok, "ASIA"}
  def get_continent_name_by_id(7), do: {:ok, "ANTARKTIDA"}
  def get_continent_name_by_id(_), do: {:error, :incorrect_continent_id}

  @spec get_continent_by_coordinates(lat :: latitude(), lon :: longitude()) :: {:ok, continent_id()}
  def get_continent_by_coordinates(lat, lon) do
    lat = maybe_convert_to_number(lat)
    lon = maybe_convert_to_number(lon)

    continents = [@n_am, @s_am, @eu, @afr, @aus, @asi, @ant]
    point = %Geo.Point{coordinates: {lat, lon}}
    find_continent(point, continents)
  end


  defp find_continent(_, []),
    do: {:ok, 0}
  defp find_continent(point, [{id, polygon} | continents]) do
    case Topo.contains?(polygon, point) do
      true -> {:ok, id}
      _ -> find_continent(point, continents)
    end
  end

  defp maybe_convert_to_number(str) when is_binary(str) do
    {number, _} = Float.parse(str)
    number
  end
  defp maybe_convert_to_number(number), do: number
end
