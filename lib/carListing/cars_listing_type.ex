defmodule CarsListingType do
  defstruct [vin: nil , dealerid: nil]

  #client side interface
  def new(carListingType \\%CarsListingType{}) do
    spawn(fn()->dataHandler(carListingType) end)
  end

  def set(dataHandler, dataSet) do
      send(dataHandler, {:set, dataSet})
  end

  def get(dataHandler, key) do
    send(dataHandler, {:get, key, self()})
    receive do
      {:value, itemValue} -> itemValue
    after 1000 -> "timeout"
    end
  end

  def get(dataHandler) do
    send(dataHandler, {:get, self()})
    receive do
      {:value, newValue} -> newValue
    after 1000 -> "timeout"
    end
  end



  #server end implementation
  def dataHandler(carListingType) do
    receive do
     # update signle key value pair
      {:set, {key,value}} ->
        newValue = %{carListingType | '#{key}': value }
        dataHandler(newValue)
      #check if input is a map and at least has vin, then update the struct by map
      {:set, %{vin:  _} = dataMap} ->
          newValue = struct(carListingType, dataMap)
          dataHandler(newValue)
      #get value from specified key
      {:get, key, parent} ->
        send(parent, {:value, carListingType |> Map.from_struct |> Map.get(:'#{key}')})
        dataHandler(carListingType)
      {:get, parent} ->
        send(parent, {:value, carListingType})
        dataHandler(carListingType)
    end
  end

end
