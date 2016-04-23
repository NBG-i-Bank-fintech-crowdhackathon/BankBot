json.array!(@messages) do |message|
  json.extract! message, :id, :user_id, :text, :response
  json.url message_url(message, format: :json)
end
