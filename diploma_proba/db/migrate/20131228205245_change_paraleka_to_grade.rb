class ChangeParalekaToGrade < ActiveRecord::Migration
  def change
		rename_column :users, :paralelka, :grade
  end
end
