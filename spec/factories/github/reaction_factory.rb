FactoryBot.define do
  factory :github_reaction, class: "Github::Reaction" do
    gid { 1000 }
    github_user_id { 75_388_869 }
    content { "+1" }

    trait :with_comment do
      reactable { association :github_comment }
    end

    trait :with_issue do
      reactable { association :github_issue }
    end

    trait :with_release do
      reactable { association :github_release }
    end
  end
end
