defmodule Collaboration.Coherence.User do
  @moduledoc false
  use Ecto.Schema
  use Coherence.Schema

  alias Collaboration.Contributions.Comment
  alias Collaboration.Contributions.Idea
  alias Collaboration.Contributions.Rating

  @passcode Application.fetch_env!(:collaboration, :passcode)
  @password Application.fetch_env!(:collaboration, :password)

  schema "users" do
    timestamps()
    coherence_schema()

    field :admin, :boolean, default: false
    field :peer, :boolean, default: false
    field :name, :string
    field :email, :string
    field :condition, :integer, default: 0
    field :completed, :boolean, default: false
    field :feedback_sequence, :integer, default: 0

    # virtual fields
    field :passcode, :string, virtual: true

    has_many :comments, Comment, on_delete: :delete_all
    has_many :feedbacks, Comment, on_delete: :delete_all
    has_many :ideas, Idea, on_delete: :delete_all
    has_many :ratings, Rating, on_delete: :delete_all

    many_to_many :likes, Comment, join_through: "likes", on_delete: :delete_all
  end

  def changeset(model, params \\ %{})

  # create admin user (via invitation or seed file)
  def changeset(model, %{ :name => _, :email => _ } = params ) do
    model
    |> cast(params, [:name, :email] ++ coherence_fields())
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/@/)
    |> put_change(:admin, true)
    |> put_change(:password, "password")
    |> put_change(:password_confirmation, "password")
    |> unique_constraint(:email)
    |> validate_coherence(params)
  end

  # create peer user (via seed file)
  def changeset(model, %{ :name => _, :peer => peer_id } = params ) do
    model
    |> cast(params, [:name] ++ coherence_fields())
    |> validate_required([:name])
    |> put_change(:peer, true)
    |> put_change(:email, "#{peer_id}@peer")
    |> put_change(:password, @password)
    |> put_change(:password_confirmation, @password)
    |> unique_constraint(:email)
    |> validate_coherence(params)
  end

  # create test user (via seed file)
  def changeset(model, %{ :name => _, :condition => condition } = params ) do
    model
    |> cast(params, [:name, :condition] ++ coherence_fields())
    |> validate_required([:name, :condition])
    |> put_change(:email, "#{condition}@test")
    |> put_change(:password, @password)
    |> put_change(:password_confirmation, @password)
    |> unique_constraint(:email)
    |> validate_coherence(params)
  end

  # for toggling admin in user list
  def changeset(model, %{:admin => _admin} = params) do
    model
    |> cast(params, [:admin])
    |> validate_inclusion(:admin, [true, false])
  end

  # for toggling peer in user list
  def changeset(model, %{:peer => _peer} = params) do
    model
    |> cast(params, [:peer])
    |> validate_inclusion(:peer, [true, false])
  end

  def changeset(model, %{:completed => _} = params) do
    model
    |> cast(params, [:completed])
    |> validate_acceptance(:completed)
  end

  def changeset(model, %{:feedback_sequence => _} = params) do
    model
    |> cast(params, [:feedback_sequence])
    |> validate_inclusion(:feedback_sequence, 0..9)
  end

  def changeset(model, params) do
    model
    |> cast(params, [:name, :email] ++ coherence_fields())
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_coherence(params)
  end

  # create user for experiment ( via default registration )
  def changeset(model, params, :experiment) do
    model
    |> cast(params, [:name, :passcode] ++ coherence_fields())
    |> validate_required([:name, :passcode])
    |> validate_length(:name, min: 3, max: 30)
    |> put_change(:passcode, String.downcase(Map.get(params, "passcode", "")))
    |> validate_inclusion(:passcode, [ @passcode ])
    |> put_change(:email, random_string(10) <>"@participant")
    |> put_change(:password, @password)
    |> put_change(:password_confirmation, @password)
    |> put_change(:condition, Enum.random(1..8))
    |> validate_coherence(params)
  end

  def changeset(model, params, :password) do
    model
    |> cast(params, ~w(password password_confirmation reset_password_token reset_password_sent_at))
    |> validate_coherence_password_reset(params)
  end

  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
