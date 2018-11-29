defmodule PrincessWeb.PageController do
  use PrincessWeb, :controller

  def index(conn, _params) do
    rows =
      1..Application.get_env(:princess, :max_value)
      |> Enum.chunk_every(10)

    render(conn, "index.html",
      welcome_text: "Welcome to Phoenix!",
      task_status: "Ready!",
      task_label: "is-primary",
      rows: rows
    )
  end
end
