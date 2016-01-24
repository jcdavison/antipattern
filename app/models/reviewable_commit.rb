include OctoHelper
include StructuralHelper
include ObjHelper

class ReviewableCommit
  attr_accessor :content, :comments
  def initialize code_review
    @content = build_commit_info code_review.opts
    @comments = build_comments code_review.opts
    save_comments code_review
    merge_comments
    self.content[:info].merge!({repo: code_review.repo, commitSha: code_review.commit_sha, context: code_review.context})
  end

  def merge_comments
    inject_comments_into comments, content
  end

  def build_commit_info opts
    build_commit_blob(OCTOCLIENT.get(octo_commit_url(opts)))
  end

  def build_comments opts
    raw_comments = grab_comments(opts, OCTOCLIENT).map {|e| e.to_attrs }
    change_key(raw_comments, :id, :github_id)
  end

  def save_comments code_review
    save_and_associate({find_key: :github_id, objects: comments, attributes: [:body, :github_id], class: 'Comment', parent: code_review})
  end
end
