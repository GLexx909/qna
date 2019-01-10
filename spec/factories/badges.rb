FactoryBot.define do

  sequence :name do |n|
    "Badge name#{n}"
  end

  factory :badge do
    name
    after(:build) do |badge|
      badge.img.attach(io: File.open(Rails.root.join('spec', 'support', 'assets', 'test_image.png')), filename: 'test_image.png', content_type: 'image/png')
    end
  end

end
