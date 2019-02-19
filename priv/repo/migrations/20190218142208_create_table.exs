defmodule CarListing.Repo.Migrations.CreateTable do
  use Ecto.Migration

  def change do
    create table(:listing) do
      add :dealer_id, :string
      add :vin, :string
      add :interface_cd, :string

      timestamps()
    end
  end
end
