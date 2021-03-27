defmodule WkJobWeb.PageController do
  @moduledoc false
  use WkJobWeb, :controller

  @doc """
  index page
  """
  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html")
  end
end
