class CreateConstantIntervals < ActiveRecord::Migration[7.1]
  def change
    create_table :constant_intervals do |t|
      t.string :name, null: false
    end
  end
end
