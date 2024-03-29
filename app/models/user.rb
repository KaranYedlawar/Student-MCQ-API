class User < ApplicationRecord
  has_one :academic, dependent: :destroy
  
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy:self

  def jwt_payload
    super
  end

  validates :role, presence: true

  enum role: { student: "student", admin: "admin", teacher: "teacher"}

  before_validation :set_default_role

  private
  def set_default_role
    self.role ||= "student"
  end
end
