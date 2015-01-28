class ReviewRequestsController < ApplicationController

  def show
    @review_request = ReviewRequest.find params[:id]
    @offers = @review_request.offers
  end

end
