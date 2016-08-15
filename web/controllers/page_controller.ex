defmodule Follow.PageController do
  use Follow.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
