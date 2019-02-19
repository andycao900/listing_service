defmodule Cars.Listing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "listing" do
    field :dealer_id, :string
    field :vin, :string
    field :interface_cd, :string

    timestamps()
  end

  def changeset(car_listing, params \\ %{}) do
    car_listing
    |> cast(params, ~w(dealer_id vin interface_cd))
    |> validate_required([:dealer_id, :vin])
  end

end
