task :update_repo_ids => :environment do
  CodeReview.where( deleted: false, repo_id: nil ).each do |code_review|
    repo_info = OCTOCLIENT.get("/repos/#{code_review.author}/#{code_review.repo}")
    code_review.repo_id = repo_info[:id]
    code_review.save
  end
end
