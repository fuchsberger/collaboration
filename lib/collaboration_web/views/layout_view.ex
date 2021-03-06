defmodule CollaborationWeb.LayoutView do
  use CollaborationWeb, :view

  import Phoenix.Controller,
    only: [ current_path: 2, get_flash: 1, view_template: 1, view_module: 1 ]

  alias CollaborationWeb.LayoutView

  @minTime Application.fetch_env!(:collaboration, :minTime)

  def button_abort(conn) do
    button raw("<i class=\"fas fa-power-off\"></i> Abort"),
      class: "btn btn-danger ml-2",
      to: Routes.session_path(conn, :delete, completed: false),
      data_confirm: "Are you sure? You will not be able to continue on your contributions and you will not receive any payout!",
      method: "delete"
  end

  def button_complete(conn) do
    button "Complete Experiment",
      id: "btn-complete",
      class: "btn btn-success ml-2",
      data_confirm: "Are you sure? This will move you to the survey!",
      to: Routes.session_path(conn, :delete, completed: true),
      method: "delete"
  end

  def button_logout(conn) do
    button content_tag(:i, "", class: "fas fa-power-off"),
      to: Routes.session_path(conn, :delete),
      class: "nav-link text-light",
      data_toggle: "tooltip",
      method: "delete",
      title: "Sign Out"
  end

  def button_timer(conn) do
    time = NaiveDateTime.add(current_user(conn).inserted_at, @minTime)
    if remaining(time) > 0 do
      content_tag :div, content_tag(:time, "", datetime: date(time)),
        id: "timer",
        class: "btn btn-light disabled ml-2"
    end
  end

  @doc """
  Returns the Google Analytics code for the current env defined in the config.
  """
  @spec ga_code() :: String.t()
  def ga_code(), do: Application.fetch_env!(:collaboration, :ga_code)

  @doc """
  Generates name for the JavaScript view we want to use
  in this combination of view/template.
  """
  def js_view_name(conn) do

    # Removes the extention from the template and returns just the name.
    template_name = view_template(conn)
    |> String.split(".")
    |> Enum.at(0)

    # Takes the resource name of view module and removes the ending: *_view*.
    view_name = view_module(conn)
    |> Phoenix.Naming.resource_name()
    |> String.replace("_view", "")

    [view_name, template_name]
    |> Enum.reverse()
    |> List.insert_at(0, "view")
    |> Enum.map(&String.capitalize/1)
    |> Enum.reverse()
    |> Enum.join("")
  end

  def nav_item(conn, text, to) do
    active = if current_path(conn, %{}) === to, do: " active", else: ""
    content_tag(:li, link(text, to: to, class: "nav-link text-light"),
      class: "nav-item #{active}")
  end

  def reload_in(conn), do: Map.get(conn.assigns, :reload_in, 0)

  def render_flash(conn) do
    Enum.map(get_flash(conn), fn { type, msg } ->
      { color, icon } = case type do
        "info" -> { "info", "fa-info-circle" }
        _ -> { "danger", "fa-exclamation-circle" }
      end
      render LayoutView, "flash.html", color: color, icon: icon, message: msg
    end)
  end
end
