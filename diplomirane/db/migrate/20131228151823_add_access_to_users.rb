class AddAccessToUsers < ActiveRecord::Migration
  def change
    add_column :users, :access, :integer, :default => 1
  end
end
