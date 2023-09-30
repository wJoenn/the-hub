FactoryBot.define do
  factory :github_user do
    gid { 1 }
    login { "wJoenn" }
    gh_type { "User" }
    avatar_url { "wJoenn/avatar" }
    html_url { "wJoenn/html" }
    bio { "A user" }
    name { "Louis Ramos" }
    location { "LLN" }
  end
end
