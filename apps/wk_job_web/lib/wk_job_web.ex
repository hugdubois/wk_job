defmodule WkJobWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use WkJobWeb, :controller
      use WkJobWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  @doc """
  Imports for controller
  """
  @spec controller() :: no_return
  def controller do
    quote do
      use Phoenix.Controller, namespace: WkJobWeb

      import Plug.Conn
      import WkJobWeb.Gettext
      alias WkJobWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  Imports for view
  """
  @spec view() :: no_return
  def view do
    quote do
      use Phoenix.View,
        root: "lib/wk_job_web/templates",
        namespace: WkJobWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  @doc """
  Imports for router
  """
  @spec router() :: no_return
  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  @doc """
  Imports for channel
  """
  @spec channel() :: no_return
  def channel do
    quote do
      use Phoenix.Channel
      import WkJobWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import WkJobWeb.ErrorHelpers
      import WkJobWeb.Gettext
      alias WkJobWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
