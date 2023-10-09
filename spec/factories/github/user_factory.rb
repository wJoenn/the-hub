FactoryBot.define do
  factory :github_user, class: "Github::User" do
    gid { 1000 }
    login { "wJoenn" }
    gh_type { "User" }
    avatar_url { "wJoenn/avatar" }
    html_url { "wJoenn/html" }
    bio { "A user" }
    name { "Louis Ramos" }
    location { "LLN" }
  end
end
