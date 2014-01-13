class AddParalelkaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :paraleka, :string
  end
end
