json.array!(@grades) do |grade|
  json.extract! grade, :id, :number, :grade
  json.url grade_url(grade, format: :json)
end
