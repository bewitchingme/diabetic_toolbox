require 'faker'

module DiabeticToolbox
  FactoryGirl.define do
    factory :members, class: Member do |member|
      password = Faker::Internet.password(8, 64)
      sequence(:email) { |n| Faker::Internet.email "#{Faker::Name.first_name}#{n}" }
      member.first_name Faker::Name.first_name
      member.last_name Faker::Name.last_name
      member.username "#{Faker::Name.first_name} #{Faker::Name.last_name}"
      member.accepted_tos true
      member.password password
      member.password_confirmation password
    end

    factory :member, class: Member do |member|
      member.sequence(:email) { |n| "frodo.baggins#{n}@example.com" }
      member.first_name 'Frodo'
      member.last_name 'Baggins'
      member.sequence(:username) { |n| "Ring Bearer#{n}" }
      member.accepted_tos true
      member.password 'password'
      member.password_confirmation 'password'

      factory :member_with_a_recipe do
        transient do
          recipes_count 1
        end

        after(:create) do |member, evaluator|
          create_list(:recipe, evaluator.recipes_count, member: member)
        end
      end

      factory :member_with_a_published_recipe do
        transient do
          recipes_count 1
        end

        after(:create) do |member, evaluator|
          create_list(:published_recipe, evaluator.recipes_count, member: member)
        end
      end
    end
  end
end