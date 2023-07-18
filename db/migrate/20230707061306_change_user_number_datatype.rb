class ChangeUserNumberDatatype < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :full_phone_number
    add_column :users, :full_phone_number, :string
  end
end