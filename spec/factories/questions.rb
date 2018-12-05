FactoryBot.define do
  sequence :title do |n|
    "Question Title#{n}"
  end

  sequence :body do |n|
    "Question Body#{n}"
  end


  factory :question do
    title
    body

    trait :invalid do
      title { nil }
    end
  end
end
