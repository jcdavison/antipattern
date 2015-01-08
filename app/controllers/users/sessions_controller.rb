class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def authorized_user
    reject_if_not_authorized_request!
    render status: 200,
          json: {
            success: true
          }
  end

  def failure
    render status: 401,
          json: {
            success: false,
            info: "Unauthorized"
          }
  end

  private

  def reject_if_not_authorized_request!
    warden.authenticate!(
      scope: resource_name, 
      recall: "#{controller_path}#failure")
  end
end
