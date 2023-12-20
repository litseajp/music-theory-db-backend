class CreateConstantChordCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :constant_chord_categories do |t|
      t.string :name, null: false
    end
  end
end
