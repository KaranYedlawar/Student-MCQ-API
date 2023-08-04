FactoryBot.define do
    factory :user do
        email { Faker::Internet.email }
        password { 'password' }
        first_name { Faker::Name.first_name }
        last_name { Faker::Name.last_name }
        full_phone_number { "+918698586828" }
        gender { 'male' }
        role { 'student' }
        country { Faker::Address.country }
        city { Faker::Address.city }
    end
end 