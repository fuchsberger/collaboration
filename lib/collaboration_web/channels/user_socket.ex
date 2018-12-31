defmodule CollaborationWeb.UserSocket do
  use Phoenix.Socket
  use Drab.Socket

  import Coherence.Config, only: [rememberable_cookie_expire_hours: 0]
  import Collaboration.Coherence.Schemas, only: [is_admin?: 1]

  alias Phoenix.Token

  @max_age rememberable_cookie_expire_hours() * 60 * 60 || ( 2 * 24 * 60 * 60 )

  ## Channels
  channel("user:*", CollaborationWeb.UserChannel)

  # connecting with user token
  def connect(%{"user_token" => token}, socket) do
    case Token.verify(socket, "user socket", token, max_age: @max_age) do
      {:ok, id} ->
        socket = socket
        |> assign(:user_id, id)
        |> assign(:admin, is_admin?(id))
        {:ok, socket}
      {:error, _reason} -> :error
    end
  end

  # connecting without user token
  def connect(_params, socket), do: {:ok, socket}
  def connect(_params, socket, _), do: {:ok, socket}

  # identify socket
  def id(socket), do: if user?(socket), do: "user:#{user_id(socket)}", else: nil

  def user_id(socket), do: Map.get(socket.assigns, :user_id, nil)
  def user?(socket), do: Map.has_key?(socket.assigns, :user_id)
  def admin?(socket), do: Map.get(socket.assigns, :admin, false)
end
