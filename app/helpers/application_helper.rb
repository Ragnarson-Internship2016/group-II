module ApplicationHelper
  # Used for styling <body> on specific pages.
  def current_context
    "#{controller_name} #{action_name}"
  end
end
