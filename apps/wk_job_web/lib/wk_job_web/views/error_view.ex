defmodule WkJobWeb.ErrorView do
  @moduledoc false
  use WkJobWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  @doc """
  By default, Phoenix returns the status message from
  the template name. For example, "404.html" becomes
  "Not Found".
  """
  @dialyzer {:nowarn_function, template_not_found: 2}
  # credo:disable-for-next-line Credo.Check.Readability.Specs
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
