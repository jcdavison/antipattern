class Vote < ActiveRecord::Base
  include WaffleHelper

  belongs_to :voteable, polymorphic: true
  belongs_to :sentiment

  COMMENT_SENTIMENT_VOTE = Proc.new do |vote| 
    ! vote.sentiment_id.nil?
  end

  validates_presence_of :value
  validates_uniqueness_of :user_id, scope: [:voteable_id, :voteable_type], :unless => COMMENT_SENTIMENT_VOTE 

  validates_each :value do |record, attr, v|
    unless v == -1 || v == 1
      record.errors.add(attr, "must be '1' or '-1'")
    end
  end

  def display_attributes
    self.attributes.keys
  end

  def self.vote_of_record_for opts
    where(opts).first
  end

  def switch_value!
    value == 1 ? self.value = -1 : self.value = 1
    save
  end
end
