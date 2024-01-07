class CreateConstantMidChordIntervals < ActiveRecord::Migration[7.1]
  def change
    create_table :constant_mid_chord_intervals do |t|
      t.references :chord, foreign_key: { to_table: :constant_chords }
      t.references :interval, foreign_key: { to_table: :constant_intervals }
    end
  end
end
