class CreateWords < ActiveRecord::Migration[5.1]
  def change
    create_table :words do |t|
      t.string :content, null: false
      t.string :meaning, null: false
      t.integer :weight, null: false, default: 0
      t.references :unit, foreign_key: true

      t.timestamps
    end
  end
end
