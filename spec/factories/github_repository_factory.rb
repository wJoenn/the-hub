FactoryBot.define do
  factory :github_repository do
    gid { 1 }
    full_name { "wJoenn/TheHub" }
    name { "wJoenn" }
    description { "A repo" }
    starred { true }
    language { "Ruby" }

    owner { create(:github_user) }

    trait :is_fake do
      full_name { "wjoenn/FakeRepo" }
    end
  end
end
