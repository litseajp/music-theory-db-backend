class CreateConstantChordPositions < ActiveRecord::Migration[7.1]
  def change
    create_table :constant_chord_positions do |t|
      t.references :chord, foreign_key: { to_table: :constant_chords }
      t.string :root, null: false
      t.integer :str1, null: false
      t.integer :str2, null: false
      t.integer :str3, null: false
      t.integer :str4, null: false
      t.integer :str5, null: false
      t.integer :str6, null: false
    end
  end
end
