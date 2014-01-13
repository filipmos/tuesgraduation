class ChangeAccess < ActiveRecord::Migration
  def change 
		change_column :users, :access, :string 
	end
end
