class AddUserIdsToGrades < ActiveRecord::Migration
  def change
		enable_extension "hstore"
		add_column :grades, :user_ids, :hstore, array: true
  end
end
