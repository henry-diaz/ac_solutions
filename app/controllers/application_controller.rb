class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource
  before_filter :set_current_user

  PER_PAGE = 20

  def set_current_user
    User.current = current_user
  end

  protected
    def layout_by_resource
      if devise_controller?
        "login"
      else
        "application"
      end
    end
end
