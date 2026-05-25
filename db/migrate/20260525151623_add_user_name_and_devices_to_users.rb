class AddUserNameAndDevicesToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :user_name, :string
    add_column :users, :devices, :string, array: true, default: []
  end
end
