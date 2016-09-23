FactoryGirl.define do
  factory :link do
    user
    title 'Valid Title'
    url 'http://www.example.com'
  end

  trait :invalid do
    title nil
    url nil
  end
end
