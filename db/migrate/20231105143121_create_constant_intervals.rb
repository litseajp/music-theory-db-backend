class CreateConstantIntervals < ActiveRecord::Migration[7.1]
  def change
    create_table :constant_intervals do |t|
      t.string :name, null: false
      t.integer :semitone_distance, null: false
      t.integer :alphabet_distance, null: false
    end
  end
end
