class CodeReviewsController < ApplicationController
  def show
    @code_review = CodeReview.find params[:id]
    @offers = @code_review.offers
  end
end
