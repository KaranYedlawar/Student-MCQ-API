class Academic < ApplicationRecord
    validates :user_id, uniqueness: true
    belongs_to :interest
    belongs_to :qualification
    belongs_to :user, dependent: :destroy
    has_one_attached :government_id
    has_one_attached :cv
end
