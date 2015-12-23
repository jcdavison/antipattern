class ApplicationController < ActionController::Base
  OCTO_DIGEST = OpenSSL::Digest.new('sha1')
  OCTO_KEY = ENV['OCTO_HOOK_SECRET']

  protect_from_forgery with: :exception
  after_filter  :set_csrf_cookie_for_ng
  class UnauthorizedOctoHook < StandardError ; end

  def after_sign_in_path_for(resource)
    code_reviews_path
  end

  def enforce_private_repo_access
    unless current_user && current_user.private_code_review_access_ids.include?(Integer(params[:id]))
      raise User::NotAuthorized 
    end
  end

  def authorized_octo_hook?
    hook_body = request.env["rack.request.form_vars"]
    expected_hook_signature = OpenSSL::HMAC.hexdigest(OCTO_DIGEST, OCTO_KEY, hook_body)
    actual_hook_signature = request.env["HTTP_X_HUB_SIGNATURE"].gsub('sha1=', '')
    unless expected_hook_signature == actual_hook_signature
      raise UnauthorizedOctoHook
    end
  end

  private
    def set_csrf_cookie_for_ng
      cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
    end

    def verified_request?
      super || form_authenticity_token == request.headers['HTTP_X_XSRF_TOKEN']
    end
end
