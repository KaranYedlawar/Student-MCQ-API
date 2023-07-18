class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :type
      t.string :first_name
      t.string :last_name
      t.integer :full_phone_number
      t.string :gender
      t.string :role
      t.string :country
      t.string :city
      t.string :state
      t.string :address

      t.timestamps
    end
  end
end
