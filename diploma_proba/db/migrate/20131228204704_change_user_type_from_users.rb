class ChangeUserTypeFromUsers < ActiveRecord::Migration
  def change
		change_column :users, :user_type, :string, :default => "student" 
  end
end
