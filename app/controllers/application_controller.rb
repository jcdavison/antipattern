class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  after_filter  :set_csrf_cookie_for_ng

  def after_sign_in_path_for(resource)
    authenticated_root_path
  end

  private

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def verified_request?
    super || form_authenticity_token == request.headers['HTTP_X_XSRF_TOKEN']
  end
end
