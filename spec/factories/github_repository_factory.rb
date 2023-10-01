FactoryBot.define do
  factory :github_repository do
    gid { 1 }
    full_name { "wJoenn/TheHub" }
    name { "wJoenn" }
    description { "A repo" }
    starred { true }
    language { "Ruby" }
    stargazers_count { 1 }
    forks_count { 1 }
    html_url { "https://www.github.com" }
    pushed_at { 1.day.ago }

    owner { association :github_user }

    trait :is_fake do
      full_name { "wjoenn/FakeRepo" }
    end
  end
end
