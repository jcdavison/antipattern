FactoryGirl.define do
  factory :vote do
    value 1
    voteable_id 1
    voteable_type 'Comment'
  end
end
