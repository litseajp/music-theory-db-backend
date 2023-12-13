class CreateConstantScaleTones < ActiveRecord::Migration[7.1]
  def change
    create_table :constant_scale_tones do |t|
      t.references :scale, foreign_key: { to_table: :constant_scales }
      t.integer :semitone_cnt, null: false
      t.references :accidental, foreign_key: { to_table: :constant_accidentals }
      t.references :interval, foreign_key: { to_table: :constant_intervals }
      t.references :tone_type, foreign_key: { to_table: :constant_tone_types }
    end
  end
end
