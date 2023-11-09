class Constant::ScaleCategory < ApplicationRecord
  has_many :scales, -> { order(:id) }
end
