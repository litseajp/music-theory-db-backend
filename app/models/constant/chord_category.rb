class Constant::ChordCategory < ApplicationRecord
  has_many :chords, -> { order(:id) }, dependent: :destroy
end
