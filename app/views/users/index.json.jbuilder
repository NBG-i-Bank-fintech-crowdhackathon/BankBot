json.array!(@users) do |user|
  json.extract! user, :id, :first_name, :last_name, :fb_id, :email, :bank_id, :account_id, :pin, :state, :clear_state, :rating, :location_lat, :location_long
  json.url user_url(user, format: :json)
end
