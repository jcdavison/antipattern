class Vote < ActiveRecord::Base
  include WaffleHelper

  belongs_to :voteable, polymorphic: true

  validates_presence_of :value
  validates_uniqueness_of :user_id, scope: [:voteable_id, :voteable_type]

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
end
