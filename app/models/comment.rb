class Comment < ActiveRecord::Base
  belongs_to :code_review
  has_many :votes, as: :voteable
end
