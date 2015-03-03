FactoryGirl.define do
  factory :offer do
    code_review_id 1
    user_id 1
    aasm_state "MyString"
  end
end
