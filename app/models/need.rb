class Need < ApplicationRecord
  belongs_to :pet

  enum need_description: [:hunger, :sleep, :attention, :happiness]
end
