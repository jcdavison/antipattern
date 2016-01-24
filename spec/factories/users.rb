FactoryGirl.define do
  factory :user do
    email 'jd@antipattern.io'
    name 'jd'
    password '123456789'
    github_profile 'http://github.com/jcdavison'
  end
end
