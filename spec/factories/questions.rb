FactoryBot.define do
    factory :question do
      ques { 'What is react?' }
      correct_answer { 'Library' }
      difficulty_level { 'level1' }
      language { 'ReactJS' }
    end
end