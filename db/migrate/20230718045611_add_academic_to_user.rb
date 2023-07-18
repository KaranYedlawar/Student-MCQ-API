class AddAcademicToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :academic_status, :boolean
  end
end
