class Vote < ActiveRecord::Base
  belongs_to :voteable, polymorphic: true
  validates_presence_of :value
  validates_each :value do |record, attr, v|
    unless v == -1 || v == 1
      record.errors.add(attr, "must be '1' or '-1'")
    end
  end
end
