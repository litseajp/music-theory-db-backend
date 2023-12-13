class Constant::Scale < ApplicationRecord
  has_many :scale_tones, -> { order(:id) }, dependent: :destroy
end
