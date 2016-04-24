json.array!(@atms) do |atm|
  json.extract! atm, :id, :name, :address, :lat, :long
  json.url atm_url(atm, format: :json)
end
