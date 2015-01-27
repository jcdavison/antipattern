class Offer < ActiveRecord::Base
  include AASM
  validates_presence_of :review_request_id, :user_id
  belongs_to :review_request
  belongs_to :user

  aasm do
    state :presented, :initial => true, :before_enter => :notify_of_offer
    state :accepted
    state :rejected
    state :delivered
    state :disputed
    state :paid

    event :accept do
      transitions from: :presented, to: :accepted
    end

    event :reject do
      transitions from: :presented, to: :rejected
    end
  end

  def notify_of_offer
    review_request_owner = User.find ReviewRequest.find(review_request_id).user_id
    offer_owner = User.find user_id
    members = {offer_owner: offer_owner, review_request_owner: review_request_owner, review_request_id: review_request_id}
    OfferMailer.notify_of_offer(members).deliver
  end

  def register_decision decision
    return self.accept! if decision == 'accept'
    return self.reject! if decision == 'reject'
  end

end
