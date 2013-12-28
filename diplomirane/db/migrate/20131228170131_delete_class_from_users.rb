class DeleteClassFromUsers < ActiveRecord::Migration
  def change
			remove_column :users, :class
  end
end
