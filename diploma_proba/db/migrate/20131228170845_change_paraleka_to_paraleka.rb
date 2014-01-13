class ChangeParalekaToParaleka < ActiveRecord::Migration
  def change
		rename_column :users, :paraleka, :paralelka
  end
end
