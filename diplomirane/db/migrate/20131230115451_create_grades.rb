class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.integer :number
      t.string :grade

      t.timestamps
    end
  end
end
