FactoryBot.define do
  factory :github_reaction, class: "Github::Reaction" do
    gid { 1 }
    github_user_id { 75_388_869 }
    content { "+1" }

    release { association :github_release }
  end
end