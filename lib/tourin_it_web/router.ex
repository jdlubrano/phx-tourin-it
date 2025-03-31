defmodule TourinItWeb.Router do
  use TourinItWeb, :router
  import TourinItWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TourinItWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :maybe_create_session_from_access_token
    plug :fetch_current_user
  end

  pipeline :admin_auth do
    plug :browser
    plug :require_admin_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TourinItWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/organize", TourinItWeb.Organize do
    pipe_through :admin_auth

    resources "/tours", TourController do
      resources "/tour_sessions", TourSessionController, except: [:index, :show]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", TourinItWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:tourin_it, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TourinItWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
