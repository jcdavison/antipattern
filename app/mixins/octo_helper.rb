module OctoHelper
  PATCH_INFO_REGEXP = /@@.{3,}@@/

  def commit_url code_review
    "/repos/#{code_review.author}/#{code_review.repo}/commits/#{code_review.commit_sha}"
  end

  def build_commit_blob octo_blob
    files = octo_blob.files.map {|f| camelize_thing(f.to_attrs) }
    modify_line_break! files
    info = camelize_thing octo_blob.commit.to_attrs
    { files: files, info: info }
  end

  def grab_comments code_review, client = nil
    author = code_review.author
    repo = code_review.repo
    sha = code_review.commit_sha
    client.send 'get', "/repos/#{author}/#{repo}/commits/#{sha}/comments"
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

  def build_octoclient token
    Octokit::Client.new :access_token => token 
  end
end
