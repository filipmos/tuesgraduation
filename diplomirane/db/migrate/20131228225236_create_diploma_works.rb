class CreateDiplomaWorks < ActiveRecord::Migration
  def change
    create_table :diploma_works do |t|
      t.string :title
      t.text :description
      t.string :student
      t.string :graduation_supervisor
      t.boolean :agreed, :default => false
      t.boolean :approved, :default => false

      t.timestamps
    end
  end
end
