class Entry < ApplicationRecord
  validates :title, :note, :place, :weather, presence: true

  def slug
    return nil unless persisted?
    "#{id}-#{title.parameterize}" # 12-human-body
  end

  def as_json(options={})
    super(:methods => ['slug'])
  end
end
