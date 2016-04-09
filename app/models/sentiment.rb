class Sentiment < ActiveRecord::Base
  validates_presence_of :name
  has_many :votes
  has_and_belongs_to_many :comments

  def self.comment_emotion_names
    %w(informative succint ambiguous kind motivating harsh)
  end

  def self.build_comment_emotions
    comment_emotion_names.each do |name|
      self.find_or_create_by name: name
    end
  end

  def self.for_comments
    comment_emotion_names.map do |name|
      self.find_by_name name
    end.compact
  end
end
