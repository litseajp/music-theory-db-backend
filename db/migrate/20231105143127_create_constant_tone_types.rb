class CreateConstantToneTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :constant_tone_types do |t|
      t.string :name, null: false
    end
  end
end
