FactoryBot.define do
  factory :feed_item do
    released_at { 1.day.ago }

    trait :with_comment do
      itemable { association :github_comment }
    end

    trait :with_release do
      itemable { association :github_release }
    end
  end
end
