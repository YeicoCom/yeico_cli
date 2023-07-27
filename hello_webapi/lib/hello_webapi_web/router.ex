defmodule HelloWebapiWeb.Router do
  use HelloWebapiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HelloWebapiWeb do
    pipe_through :api

    get "/", ApiController, :index
  end
end
