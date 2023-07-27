defmodule HelloWebapiWeb.ApiController do
  use HelloWebapiWeb, :controller

  def index(conn, _params) do
    json(conn, %{id: "Hello WebApi"})
  end
end
