include CommitHelper
include StructuralHelper

class Api::ReviewsController < ApplicationController

  PATCH_INFO_REGEXP = /@@.+@@/
  before_filter :authenticate_user!, except: [:index, :show]
  respond_to :json

  def index
    @code_reviews = CodeReview.all_active.order(created_at: :desc)
    render 'api/reviews/index'
  end

  def show
    @code_review = CodeReview.preload(:user).find params[:id]
    @code_review_owner = @code_review.user.to_waffle.attributes!
    commit_blob = build_commit_blob(OCTOCLIENT.get(commit_url(@code_review))) 
    @comments = grab_comments(@code_review).map {|e| e.to_attrs }
    @commit_blob = inject_comments_into @comments, commit_blob
    @commit_blob[:info].merge!({repo: @code_review.repo, commitSha: @code_review.commit_sha})
    render json: {commit: @commit_blob, codeReviewOwner: @code_review_owner, codeReviewId: @code_review.id}
  end

  def create
    @code_review = CodeReview.new(code_review_params.merge(user_id: current_user.id))
    topic_list = tagize_topics params[:code_review][:topics]
    @code_review.topic_list = topic_list
    if @code_review.save
      # @members_notified = @code_review.notify_subscribers
      render 'api/reviews/create'
    else
      head :forbidden
    end
  end

  def owned_by
    code_review = CodeReview.find_by(user_id: current_user.id, id: params[:id])
    owned_by = !code_review.nil?
    render json: { owned_by: owned_by}
  end

  def update
    @code_review = CodeReview.find_by(user_id: current_user.id, id: params[:code_review][:id])
    if @code_review.update_attributes(code_review_params)
      render 'api/reviews/update'
    else
      head :forbidden
    end
  end

  def destroy
    @code_review = CodeReview.find_by(id: params[:id])
    @code_review.deleted = true
    if @code_review.save
      head :ok
    else
      head :forbidden
    end
  end

  private

    def code_review_params
      params.require(:code_review).compact.permit(:repo, :commit_sha, :title)
    end

    def tagize_topics enum_data
      enum_data.join(', ')
    end

    def build_commit_blob octo_blob
      files = octo_blob.files.map {|f| camelize_thing(f.to_attrs) }
      modify_line_break! files
      info = camelize_thing octo_blob.commit.to_attrs
      { files: files, info: info }
    end

    def grab_comments code_review
      user = code_review.user.github_username
      repo = code_review.repo
      sha = code_review.commit_sha
      OCTOCLIENT.get "/repos/#{user}/#{repo}/commits/#{sha}/comments"
    end

    def inject_comments_into comments, commit_blob
      commit_blob[:files] = commit_blob[:files].each {|f| f[:comments] = []}
      comments.inject(commit_blob) do |commit, comment|
        commit[:files].each do |file|
          file[:comments].push comment if file[:filename] == comment[:path]
        end
        commit_blob
      end
    end

    def modify_line_break! things
      things.each do |thing|
        # thing[:patch] = thing[:patch].gsub('\n','\\n')
        thing[:patches] = thing[:patch].lines
        thing[:patches] = thing[:patches].inject([]) do |patch, line|
          if line.match PATCH_INFO_REGEXP
            patch.push [line]
          else
            patch.last.push line
          end
          patch
        end
      end
    end
end
