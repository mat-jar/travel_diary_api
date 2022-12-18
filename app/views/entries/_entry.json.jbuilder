json.extract! entry, :id, :title, :place, :note, :weather, :created_at, :updated_at
json.url entry_url(entry, format: :json)
