class Offer < ActiveRecord::Base
  include AASM
  validates_presence_of :review_request_id, :user_id

  aasm do
    state :presented, :initial => true
    state :accepted
    state :rejected
    state :delivered
    state :disputed
    state :paid

    event :accept do
      transitions from: :presented, to: :accepted
    end
  end
end
