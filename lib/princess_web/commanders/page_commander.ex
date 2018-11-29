defmodule PrincessWeb.PageCommander do
  use Drab.Commander

  @max_value Application.get_env(:princess, :max_value)
  onload(:page_loaded)
  @sleep_ms 100

  # Drab Callbacks
  def page_loaded(socket) do
    poke(socket, welcome_text: "Welcome to the Math Myth!")
  end

  defhandler calc_div(socket, sender) do
    poke(socket, task_status: "Running!", task_label: "is-danger")
    set_attr(socket, ".task[task-id", class: "task is-primary")
    value = ensure(sender["value"])

    case value do
      0 -> nil
      _ -> process(socket, value)
    end

    poke(socket, task_status: "Success!", task_label: "is-success")
  end

  defp ensure(""), do: 0

  defp ensure(value) do
    value = String.to_integer(value)

    case value > @max_value or value < 1 do
      true -> 0
      _ -> value
    end
  rescue
    _ -> 0
  end

  defp process(socket, value) do
    tasks =
      Enum.map(1..@max_value, fn i ->
        Task.async(fn ->
          # simulate real work
          case rem(i, value) == 0 do
            true ->
              Process.sleep(:rand.uniform(@sleep_ms))
              set_prop(socket, ".task[task-id='#{i}']", className: "task is-success")

            _ ->
              nil
          end
        end)
      end)

    Enum.each(tasks, fn task -> Task.await(task) end)
  end
end
