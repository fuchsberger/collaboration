defmodule CollaborationWeb.TopicChannel do
  use CollaborationWeb, :channel
  import Collaboration.Contributions
  alias Phoenix.View
  alias CollaborationWeb.IdeaView

  def join("topic:"<> id, params, socket) do
    last_seen_id = params["last_seen_id"] || 0
    topic = get_topic!(id)
    ideas = list_ideas(topic.id, last_seen_id)
    resp = %{ ideas: View.render_many(ideas, IdeaView, "idea.json") }
    {:ok, resp, assign(socket, :topic, topic)}
  end

  def handle_in("new:idea", data, socket) do
    if authorized?(socket) do
      case create_idea(socket.assigns.user, socket.assigns.topic, data) do
        {:ok, idea} ->
          idea = get_idea_details(idea)
          broadcast! socket, "new:idea", View.render_one(idea, IdeaView, "idea.json")
          {:reply, {:ok, %{}}, socket}
        {:error, changeset} ->
          {:reply, {:error, %{ errors: error_map(changeset) }}, socket}
      end
    else
      {:reply, {:error, %{}}, socket}
    end
  end

  def handle_in("update:idea", data, socket) do
    if authorized?(socket) do
      case get_idea!(data["id"]) |> update_idea(data) do
        {:ok, idea} ->
          idea = get_idea_details(idea)
          broadcast! socket, "update:idea", View.render_one(idea, IdeaView, "idea.json")
          {:reply, {:ok, %{}}, socket}
        {:error, changeset} ->
          {:reply, {:error, %{ errors: error_map(changeset) }}, socket}
      end
    else
      {:reply, {:error, %{}}, socket}
    end
  end

  defp authorized?(socket), do:
    Map.has_key?(socket.assigns, :user) && (
      socket.assigns.user.admin || socket.assigns.topic.open
    )
end