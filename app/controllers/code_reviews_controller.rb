include CommitHelper
include StructuralHelper
class CodeReviewsController < ApplicationController

  def show
    @code_review = CodeReview.find params[:id]
    @commit_blob = build_commit_blob(OCTOCLIENT.get(commit_url(@code_review))) 
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

    def modify_line_break! things
      things.each do |thing|
        # thing[:patch] = thing[:patch].gsub('\n','\\n')
        thing[:patch] = thing[:patch].lines
      end
    end
end
