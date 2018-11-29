defmodule PrincessWeb.PageCommander do
  use Drab.Commander

  onload(:page_loaded)

  # Drab Callbacks
  def page_loaded(socket) do
    poke(socket, welcome_text: "Welcome to the Math Myth!")
  end

  defhandler calc_div(socket, sender) do
    poke(socket, task_status: "Running!", task_label: "is-danger")
    set_attr(socket, ".task[task-id", class: "task is-primary")
    value = String.to_integer(sender["value"])

    tasks =
      Enum.map(1..100, fn i ->
        Task.async(fn ->
          # simulate real work
          case rem(i, value) == 0 do
            true ->
              Process.sleep(:rand.uniform(500))
              set_prop(socket, ".task[task-id='#{i}']", className: "task is-success")

            _ ->
              nil
          end
        end)
      end)

    Enum.each(tasks, fn task -> Task.await(task) end)
    Process.sleep(1 * 1000)
    IO.puts(value)

    poke(socket, task_status: "Success!", task_label: "is-success")
  end
end
