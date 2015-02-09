class ReviewRequest < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :value, :detail, :user_id, :title
  has_many :offers

  scope :all_active, -> {where(deleted: false)}

  def display_value
    (value.to_f / 100)
  end

  def has_offers?
    ! offers.empty?
  end
end
