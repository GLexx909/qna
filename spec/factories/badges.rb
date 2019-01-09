FactoryBot.define do

  sequence :name do |n|
    "Badge name#{n}"
  end

  sequence :img do |n|
    "http://img#{n}.png"
  end

  factory :badge do
    name
    img
  end

end
