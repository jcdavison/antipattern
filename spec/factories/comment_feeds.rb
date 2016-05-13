FactoryGirl.define do
  factory :comment_feed do
    repository "foo-code"
    github_identity 'foo-user'
    user_id 1
  end
end
