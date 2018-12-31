defmodule Collaboration.Repo.Migrations.Contributions do
  use Ecto.Migration

  def change do
    create table(:topics) do
      add :title, :string
      add :short_title, :string
      add :short_desc, :text
      add :desc, :text
      add :featured, :boolean, default: false, null: false
      add :published, :boolean, default: false, null: false
      timestamps()
    end

    create table(:ideas) do
      add :text, :text
      add :fake_rating, :float
      add :fake_raters, :integer, default: 0
      add :topic_id, references(:topics, on_delete: :delete_all)
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)
      timestamps()
    end

    create table(:comments) do
      add :text, :text
      add :fake_likes, :integer, null: false, default: 0
      add :idea_id, references(:ideas, on_delete: :delete_all)
      add :recipient_id, references(:users, type: :binary_id, on_delete: :delete_all)
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)
      timestamps()
    end

    create table(:ratings) do
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)
      add :idea_id, references(:ideas, on_delete: :delete_all)
      add :rating, :integer
    end
    create unique_index(:ratings, [:user_id, :idea_id])

    create table(:likes) do
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)
      add :comment_id, references(:comments, on_delete: :delete_all)
    end
    create unique_index(:likes, [:user_id, :comment_id])
  end
end
