class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :status
      t.date :date
      t.integer :rate

      t.timestamps
    end
  end
end
