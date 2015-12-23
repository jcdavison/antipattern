module OctoHelper
  PATCH_INFO_REGEXP = /@@.{3,}@@/
  WEBHOOK_EVENTS = ['push', 'membership', 'member', 'public']
  WEBHOOK_SERVER = ENV['WEB_HOOK_SERVER']
  OCTO_HOOK_SECRET = ENV['OCTO_HOOK_SECRET']

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

  def get_repo opts, collaborators = false
    client = build_octoclient opts[:token]
    fragment = collaborators == true ? '/collaborators' : ''
    client.get "repos/#{opts[:author]}/#{opts[:repo]}#{fragment}"
  end

  def get_collaborators opts
    get_repo(opts, true).map { |collaborator| collaborator[:login] }
  end

  def create_webhook opts
    client = build_octoclient opts[:token]
    url = webhook_url opts
    config = { url: url, config_type: 'json', secret: OCTO_HOOK_SECRET }
    post_body = {name: 'web', events: WEBHOOK_EVENTS, active: true, config: config}
    client.post "/repos/#{opts[:author]}/#{opts[:repo]}/hooks", post_body
  end

  def webhook_url opts
    "#{WEBHOOK_SERVER}/api/hooks/code_review/#{opts[:repo]}"
  end

  def has_valid_octo_webhook? opts
    hooks = get_octo_hooks(opts).map {|hook| {url: hook[:config][:url], events: hook[:events]} }
    hooks.any? {|hook| hook[:url].match("#{Regexp.new(opts[:repo])}") && hook[:events] == WEBHOOK_EVENTS }
  end

  def get_octo_hooks opts
    client = build_octoclient opts[:token]
    client.get "/repos/#{opts[:author]}/#{opts[:repo]}/hooks"
  end

  def clear_octo_hooks! opts
    client = build_octoclient opts[:token]
    get_octo_hooks(opts).map do |hook|
      if hook[:config][:url].match Regexp.new(WEBHOOK_SERVER)
        client.delete "/repos/#{opts[:author]}/#{opts[:repo]}/hooks/#{hook[:id]}"
      end
    end
  end
end
