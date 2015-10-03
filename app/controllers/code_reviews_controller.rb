include CommitHelper
include StructuralHelper
class CodeReviewsController < ApplicationController

  def show
    @code_review = CodeReview.find params[:id]
    commit_blob = build_commit_blob(OCTOCLIENT.get(commit_url(@code_review))) 
    # binding.pry
    @comments = grab_comments(@code_review).map {|e| e.to_attrs }
    @commit_blob = inject_comments_into @comments, commit_blob
    # binding.pry
    # rescue 
    #   redirect_to authenticated_root_path
  end

  private

    def build_commit_blob octo_blob
      files = octo_blob.files.map {|f| camelize_thing(f.to_attrs) }
      modify_line_break! files
      info = camelize_thing octo_blob.commit.to_attrs
      { files: files, info: info }
    end

    def grab_comments code_review
      OCTOCLIENT.get "/repos/jcdavison/#{code_review.repo}/commits/#{code_review.commit_sha}/comments"
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
        thing[:patch] = thing[:patch].lines
      end
    end
end
