class User < ActiveRecord::Base
	has_many :messages
	def create_from_fb(fb_id)
		conn = Faraday.new(:url => 'https://graph.facebook.com/v2.6') do |faraday|
      		faraday.request  :url_encoded             # form-encode POST params
      		faraday.response :logger                  # log requests to STDOUT
      		faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    	end
    	profile = conn.get "/#{fb_id}?access_token=#{config.ai_token}"
    	profile = JSON.parse profile.body
    	return User.create(:fb_id => fb_id, :first_name => profile["first_name"], :last_name => profile["last_name"])
    	
	end
end
