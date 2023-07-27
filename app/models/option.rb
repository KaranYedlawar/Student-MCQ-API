class Option < ApplicationRecord
  belongs_to :question
  validates :choice, presence: true
end
