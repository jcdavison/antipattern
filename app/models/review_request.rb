class ReviewRequest < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :value, :detail, :user_id, :title

  def display_value
    '$' << (value.to_f / 100).to_s
  end
end
