class CreateConstantChords < ActiveRecord::Migration[7.1]
  def change
    create_table :constant_chords do |t|
      t.references :chord_category, foreign_key: { to_table: :constant_chord_categories }
      t.string :path, null: false
      t.string :quality, null: false
      t.string :name, null: false
      t.text :description
    end
  end
end
