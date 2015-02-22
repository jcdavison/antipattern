class Wallet < ActiveRecord::Base
  belongs_to :user

  def ready_to_pay?
    ! stripe_access_token.nil?
  end
end
