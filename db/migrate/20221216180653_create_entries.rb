class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.string :title
      t.string :place
      t.text :note
      t.string :weather

      t.timestamps
    end
  end
end
