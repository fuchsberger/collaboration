defmodule CollaborationWeb.IdeaView do
  use CollaborationWeb, :view

  alias Collaboration.Contributions.Comment

  def raters(idea) do
    raw "/ #{idea.raters} #{ngettext "rating", "ratings", idea.raters}"
  end

  def color(idea, value) do
    if idea.my_rating && idea.my_rating >= value,
      do: "text-primary",
      else: "text-muted"
  end

  def changeset(idea, changeset) do
    if is_nil(changeset) || idea.id != changeset.changes.idea_id do
      Collaboration.Contributions.change_comment(%Comment{})
    else
      changeset
    end
  end

  def base_rating(rating, raters) do
    cond do
      raters === 0 ->  "base0"
      rating >= 4.5 -> "base5"
      rating >= 3.5 -> "base4"
      rating >= 2.5 -> "base3"
      rating >= 1.5 -> "base2"
      true ->          "base1"
    end
  end

  def edit?(changeset), do: Map.has_key?(changeset, :id)

  def idea_id(conn) do
    if Map.has_key?(conn.params, "id"),
      do: Map.get(conn.params, "id") |> String.to_integer,
      else: nil
  end

  def topic_id(conn), do: Map.get(conn.params, "topic_id", conn.params["id"])

  def active?(idea, idea_id) do
    if idea.id === idea_id, do: " table-active"
  end

  # calculates rating for an idea
  def calc_rating(rating, raters, my_rating, old_rating \\ nil) do
    all_raters = if my_rating && !old_rating, do: raters + 1, else: raters
    rating = cond do
      old_rating ->
        Float.round((rating * raters + my_rating - old_rating) / all_raters, 2)
      all_raters === 0 ->
        nil
      !my_rating ->
        Float.round(rating/1, 2)
      my_rating && !rating ->
        Float.round(my_rating / all_raters, 2)
      true ->
        Float.round((rating * raters + my_rating) / all_raters, 2)
    end
    {rating, all_raters}
  end

  def render("idea.json", %{ idea: i, user: u, bot_comments: bot_comments }) do


    inserted_at = if u.condition == 0 || i.user_id == u.id,
      do: i.inserted_at,
      else: NaiveDateTime.add(u.inserted_at, Map.get(i, condition(u)))

    my_rating = if Ecto.assoc_loaded?(i.ratings) && i.ratings != [],
      do: List.first(i.ratings).rating,
      else: nil

    { rating, raters } = calc_rating(i.fake_rating, i.fake_raters, my_rating)

    comments =
      # add relevant bot comments
      i.comments
      |> Enum.filter(fn c -> Enum.member?(u.comments, c.id) end)
      |> Enum.map(fn c -> Enum.find_index(u.comments, fn x -> x == c.id end) end)
      |> Enum.map(fn i -> Enum.fetch!(bot_comments, i) end)
      # and existing comments for current idea
      |> Enum.concat(i.comments)
      |> View.render_many(CommentView, "comment.json", user: u)
      |> Enum.sort_by(fn(c) -> c.inserted_at end)

    reload_in =
      comments
      |> Enum.map(fn c -> c.inserted_at end)
      |> Enum.filter(fn t -> remaining(t) > 0 end)
      |> List.first()

    reload_in =
      case reload_in do
        nil -> nil
        time -> remaining(time) * 1000
      end


    %{
      id: i.id,
      comments: comments,
      inserted_at: inserted_at,
      my_rating: my_rating,
      rating: if is_nil(rating) do nil else Float.round(rating, 1) end,
      raters: raters,
      text: i.text,
      reload_in: reload_in,
      user_id: i.user_id,
      user: i.user.name
    }
  end

end
