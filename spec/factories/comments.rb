FactoryBot.define do
  factory :comment do
    content { "MyString" }
    user { nil }
    Article { nil }
  end
end
