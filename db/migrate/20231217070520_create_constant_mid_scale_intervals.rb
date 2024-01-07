class CreateConstantMidScaleIntervals < ActiveRecord::Migration[7.1]
  def change
    create_table :constant_mid_scale_intervals do |t|
      t.references :scale, foreign_key: { to_table: :constant_scales }
      t.references :interval, foreign_key: { to_table: :constant_intervals }
      t.references :tone_type, foreign_key: { to_table: :constant_tone_types }
    end
  end
end
