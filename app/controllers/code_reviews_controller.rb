include CommitHelper
include StructuralHelper
class CodeReviewsController < ApplicationController
  PATCH_INFO_REGEXP = /@@.+@@/

  def show
    @code_review = CodeReview.preload(:user).find params[:id]
    @code_review_owner = @code_review.user.to_waffle.attributes!
    commit_blob = build_commit_blob(OCTOCLIENT.get(commit_url(@code_review))) 
    @comments = grab_comments(@code_review).map {|e| e.to_attrs }
    p '@comments'
    p @comments.class
    p @comments.length
    p @comments
    save_and_associate({find_key: :github_id, objects: @comments, attributes: [:body, {github_id: :id}], class: 'Comment', parent: @code_review})
    @commit_blob = inject_comments_into @comments, commit_blob
    @commit_blob[:info].merge!({repo: @code_review.repo, commitSha: @code_review.commit_sha})
    # rescue 
    #   redirect_to authenticated_root_path
  end

  private

    def save_and_associate opts
      opts[:objects].each do |obj|
        obj_attributes = opts[:attributes].inject({}) do |attr_map, attribute|
          look_up_key = attribute.is_a?(Hash) ? attribute.values.first : attribute
          local_modal_key = attribute.is_a?(Hash) ? attribute.keys.first : attribute
          attr_map[local_modal_key] = eval("obj[:#{look_up_key}]")
          attr_map
        end
        new_obj = eval("#{opts[:class]}.find_or_create_by(opts[:find_key] => #{obj_attributes[opts[:find_key]]})")
        new_obj.update_attributes obj_attributes
        parent = opts[:parent]
        association = opts[:class].downcase.pluralize
        eval("parent.send(association) << new_obj")
      end
    end

    def build_commit_blob octo_blob
      files = octo_blob.files.map {|f| camelize_thing(f.to_attrs) }
      modify_line_break! files
      info = camelize_thing octo_blob.commit.to_attrs
      { files: files, info: info }
    end

    def grab_comments code_review
      OCTOCLIENT.get "/repos/#{code_review.user.github_username}/#{code_review.repo}/commits/#{code_review.commit_sha}/comments"
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
