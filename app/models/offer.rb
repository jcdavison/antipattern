class Offer < ActiveRecord::Base
  include AASM
  validates_presence_of :code_review_id, :user_id
  belongs_to :code_review
  belongs_to :user

  aasm do
    state :presented, :initial => true, :before_enter => :notify_of_offer
  end

  def recipients
    offer_owner = user
    code_review_owner = code_review.user
    {offer_owner: offer_owner, code_review_owner: code_review_owner, code_review: code_review, offer: self}
  end

  def notify_of_offer
    OfferMailer.notify_of_offer(recipients).deliver
  end
end
