class Question < ApplicationRecord
    has_many :options, dependent: :destroy

    accepts_nested_attributes_for :options, allow_destroy: true
    
    validates :difficulty_level, :ques, :correct_answer, presence: true
    enum difficulty_level: { level1: "level1", level2: "level2", level3: "level3" }

    validates :language, presence: true
    enum language: { Ruby: "Ruby", ReactJS: "ReactJS", ReactNative: "ReactNative" }
    

end
