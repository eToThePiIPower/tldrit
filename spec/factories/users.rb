FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "person#{n}@example.com"
    end
    sequence :username do |n|
      "person#{n}"
    end
    password 'password'
  end
end
