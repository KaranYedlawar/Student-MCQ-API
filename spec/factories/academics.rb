FactoryBot.define do
    factory :academic do
      association :user
      qualification { "M.Sc in computer" }
      interest { "Data Analyst" }
      government_id { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'PremiereProTutorial.pdf'), 'pdf') }
      cv { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'What+is+a+REST+API.pdf'), 'pdf') }
    end
  end
  