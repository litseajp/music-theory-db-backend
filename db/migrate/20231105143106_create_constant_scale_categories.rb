class CreateConstantScaleCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :constant_scale_categories do |t|
      t.string :name, null: false
    end
  end
end
