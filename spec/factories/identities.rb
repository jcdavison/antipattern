FactoryGirl.define do
  factory :identity do
    provider "github_private_scope"
    uid ENV['GH_UID']
    token ENV['GH_IDENTITY_TOKEN']
  end
end
