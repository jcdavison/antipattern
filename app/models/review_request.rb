class ReviewRequest < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :value, :detail, :user_id
end
