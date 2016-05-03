include OctoHelper
include StructuralHelper
include ObjHelper

class CommentsList
  attr_accessor :comments, :comment_records, :raw_comments

  def initialize opts
    @client = opts[:client]
    @repo = opts[:repo]
    @user = opts[:user]
    @raw_comments = get_comments
    change_key(@raw_comments, :id, :github_id)
    @comment_records = save_and_process_comments
    @comments = group_by_commit
  end

  def get_comments
    @client.get("/repos/#{@user}/#{@repo}/comments")
  end

  def save_and_process_comments
    @raw_comments.inject([]) do |collection, raw_comment|
      comment = Comment.find_by_github_id(raw_comment[:github_id])
      if comment.nil?
        comment = Comment.new(github_id: raw_comment[:github_id])
        comment.save
      end
      raw_comment[:user] = raw_comment[:user].to_h
      raw_comment[:id] = comment.id
      comment_obj = { comment: raw_comment.to_h, 
                      repo: @repo, 
                      sentiments: comment.sentiments_as_opts,
                      votes: comment.votes }
      collection.push( comment_obj )
    end
  end

  def group_by_commit
    @comment_records.inject({}) do |collection, comment|
      comment_key = comment[:comment][:commit_id]
      if collection[comment_key]
        collection[comment_key].push comment
      else
        collection[comment_key] = [comment]
      end
      collection
    end
  end
end
