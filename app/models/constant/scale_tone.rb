class Constant::ScaleTone < ApplicationRecord
  belongs_to :accidental
  belongs_to :interval
  belongs_to :tone_type
end
