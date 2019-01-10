class CreateTableBadge < ActiveRecord::Migration[5.2]
  def change
    create_table :badges do |t|
      t.string :name, null: false
      t.belongs_to :question

      t.timestamps
    end
  end
end
