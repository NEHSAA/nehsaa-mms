module ResponseStatus
  extend ActiveSupport::Concern

  def render_forbidden_status
    render 'status/forbidden', status: 403
  end

  def render_not_found_status
    render 'status/not_found', status: 404
  end

end
