class CreateConstantScales < ActiveRecord::Migration[7.1]
  def change
    create_table :constant_scales do |t|
      t.references :scale_category, foreign_key: { to_table: :constant_scale_categories }
      t.string :path, null: false
      t.string :name, null: false
      t.text :description
    end
  end
end
