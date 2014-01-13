class AddBusinessToUser < ActiveRecord::Migration
  def change
    add_column :users, :business, :string
  end
end
