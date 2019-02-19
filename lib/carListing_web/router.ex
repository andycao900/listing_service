defmodule CarListingWeb.Router do
  use CarListingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CarListingWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/", CarListingWeb do
    pipe_through :api # Use the default api stack

    put "/listings", RestController, :add_listings
    get "/listings", RestController, :get_listings

  end

  # Other scopes may use custom stacks.
  # scope "/api", CarListingWeb do
  #   pipe_through :api
  # end
end
