FactoryBot.define do
  factory :comment do
    body { "CommentBody" }
  end

  trait :invalid do
    body { nil }
  end
end
