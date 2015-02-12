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
      before do
        notify_acceptance
      end
      transitions from: :presented, to: :accepted
    end

    event :reject do
      before do 
        notify_rejection
      end
      transitions from: :presented, to: :rejected
    end

    event :deliver do
      transitions from: :accepted, to: :delivered
    end

    event :pay do
      transitions from: :delivered, to: :paid
    end

    event :dispute do
      transitions from: :delivered, to: :disputed
    end
  end

  def notify_acceptance
    offer_owner = user
    review_request_owner = review_request.user
    recipients = {offer_owner: offer_owner, review_request_owner: review_request_owner}
    OfferMailer.notify_acceptance(recipients).deliver
  end

  def notify_rejection
    offer_owner = user
    review_request_owner = review_request.user
    recipients = {offer_owner: offer_owner, review_request_owner: review_request_owner}
    OfferMailer.notify_rejection(recipients).deliver
  end

  def notify_of_offer
    review_request_owner = User.find ReviewRequest.find(review_request_id).user_id
    offer_owner = User.find user_id
    members = {offer_owner: offer_owner, review_request_owner: review_request_owner, review_request_id: review_request_id}
    OfferMailer.notify_of_offer(members).deliver
  end

  def set_state! new_state
    return self.accept! if new_state == 'accept'
    return self.reject! if new_state == 'reject'
    return self.deliver! if new_state == 'deliver'
    return self.pay! if new_state == 'pay'
    return self.dispute! if new_state == 'dispute'
  end

end
