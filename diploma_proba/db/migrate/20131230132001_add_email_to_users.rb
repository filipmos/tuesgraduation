class AddEmailToUsers < ActiveRecord::Migration
  def change
		enable_extension "hstore"
    add_column :users, :email, :hstore, array: true
  end
end
