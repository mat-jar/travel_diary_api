class AddUserRefToEntries < ActiveRecord::Migration[7.0]
  def change
    add_reference :entries, :user, foreign_key: true
  end
end
