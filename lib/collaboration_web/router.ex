defmodule CollaborationWeb.Router do
  use CollaborationWeb, :router
  use Coherence.Router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Coherence.Authentication.Session)
    plug(CollaborationWeb.Plug.LoadTopics)
  end

  pipeline :protected do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Coherence.Authentication.Session, protected: true, login: true)
    plug(Coherence.Authentication.Token, source: :params, param: "auth_token")
    plug(CollaborationWeb.Plug.LoadTopics)
  end

  scope "/" do
    pipe_through(:browser)
    coherence_routes()
  end

  scope "/" do
    pipe_through(:protected)
    coherence_routes(:protected)
  end

  scope "/", CollaborationWeb do
    pipe_through(:browser)

    # add public resources below
    get("/", PageController, :index)
    get("/topics", TopicController, :index)
    get("/topic/:id", TopicController, :show)
  end

  scope "/", CollaborationWeb do
    pipe_through(:protected)

    # add protected resources below
    resources("/topic", TopicController, only: [:edit, :update, :delete])
    resources("/topics", TopicController, only: [:new, :create])
    get("/users2", AdminController, :users)

    resources("/users", UserController, only: [:index, :update])
  end
end
