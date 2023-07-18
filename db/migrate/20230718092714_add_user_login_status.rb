class AddUserLoginStatus < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :login_status, :boolean
  end
end
