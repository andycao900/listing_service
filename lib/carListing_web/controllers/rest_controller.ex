defmodule CarListingWeb.RestController do
  use CarListingWeb, :controller
  import CarsListingType
  alias Cars.Listing
  alias CarListing.Repo
  import Ecto.Query, only: [from: 1]

  require Logger


  def index(conn, _params) do
    render conn, "index.html"
  end

  def  get_listings(conn, params) do

    result = from(listing in Listing) |> Repo.all() |> Poison.encode!(pretty: true) |> IO.inspect

    conn
      |> put_resp_header("content-type", "application/json; charset=utf-8")
      |> send_resp(200, result)

  end

  def add_listings(conn, %{ "listings" => listings}) do
    #Parameters: %{"listings" => [%{"carsDealerId" => "178178", "vin" => "8750YVHZ8Ds6C5M323"}, %{"carsDealerId" => "178179", "interiorColor" => "Steel Gray", "vin" => "8750YVHZ8Ds6C5M324"}]}
    #listings will be matched to a list of data maps, each map look like (%{"carsDealerId" => "178178", "vin" => "8750YVHZ8Ds6C5M323"})

    #enum, stream, flow; flow.map vs. flow.each
    {total_insert, total_reject} =
      listings
      |> Flow.from_enumerable(max_demand: 10,min_demand: 5,stages: 10 )
      |> Flow.map(&normalize_listing_object/1)
      |> Flow.map(&save_data/1)
      |> Enum.to_list()
      |> Enum.split_with(&if_insert_ok/1)



    send_resp(conn, 200, "#{Enum.count(total_insert)} listings was saved, #{Enum.count(total_reject)} listings was rejected")
  end

  def if_insert_ok({status,_}) do
    status == :ok
  end

  def save_data(list_data) do
      %Listing{}
       |> Listing.changeset(list_data)
       |> Repo.insert
  end

  def normalize_listing_object(x) do
    :timer.sleep(30)
    # x is a map  %{"carsDealerId" => "178178", "vin" => "8750YVHZ8Ds6C5M323"}
    x
    |> Enum.into( %{}, &normalize_listing_field/1)
    |> IO.inspect

    #pid =  CarsListingType.new()
    #CarsListingType.set(pid, y)
    #CarsListingType.get(pid)

  end

  def normalize_listing_field({key, value}) do

    #convert-map-keys-from-strings-to-atoms
    newKey = String.to_atom(key)
    case  key do
       "vin"            ->  { newKey, value}
       "carsDealerId"   ->  { String.to_atom("dealer_id") , value}
       _                ->  { newKey, value}
      end
  end
end

defimpl Poison.Encoder, for: Any do
  def encode(%{__struct__: _} = struct, options) do
    map = struct
          |> Map.from_struct
          |> sanitize_map
    Poison.Encoder.Map.encode(map, options)
  end

  defp sanitize_map(map) do
    Map.drop(map, [:__meta__, :__struct__])
  end
end
