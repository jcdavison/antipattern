class CodeReviewsController < ApplicationController
  def show
    @code_review = CodeReview.find params[:id]
    @offers = @code_review.offers
    rescue 
      redirect_to authenticated_root_path
  end
end
