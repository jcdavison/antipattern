class Api::TopicsController < ApplicationController
  def index
    topics = CodeReview.avail_topics.each_with_index.map do |topic, index| 
      { text: topic, id: topic }
    end
    render json: { topics: topics }
  end
end
