class CreateConstantAccidentals < ActiveRecord::Migration[7.1]
  def change
    create_table :constant_accidentals do |t|
      t.string :name, null: false
    end
  end
end
