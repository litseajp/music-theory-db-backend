class Constant::Chord < ApplicationRecord
  has_many :mid_chord_intervals, dependent: :destroy
  has_many :intervals, through: :mid_chord_intervals
end
