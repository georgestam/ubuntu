json.array! @recordings do |recording|
  json.extract! recording, :id, :data, :description
end