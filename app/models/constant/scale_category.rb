class Constant::ScaleCategory < ApplicationRecord
  has_many :scales, -> { order(:id) }, dependent: :destroy
end
