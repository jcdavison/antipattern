module CommitHelper
  def commit_url code_review
    "/repos/#{code_review.user.github_username}/#{code_review.repo}/commits/#{code_review.commit_sha}"
  end
end
