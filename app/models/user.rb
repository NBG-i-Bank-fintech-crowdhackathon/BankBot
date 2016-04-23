class User < ActiveRecord::Base
	has_many :messages
  @@fb_token = 'CAAW46Pf7Xo4BANlo4Unadya2BeLtUt3CO5hohlqPbn1ZCrLwbGwKQCdBQrjNFaWp0ilYlt1A4hBKebRuZA0Rai4R1wIfAsMdn3DG0jGoea2iU2frQbCcO25LQ9VEqtqMvdT07G8BbxEAXfBiOqy3NfP12t7rWp0gU7h6hRT9mPSqNfehST1fARJf2oXpBewLwMmuZBKdAZDZD'

	def self.create_from_fb(fb_id)
		conn = Faraday.new(:url => 'https://graph.facebook.com/v2.6') do |faraday|
      		faraday.request  :url_encoded             # form-encode POST params
      		faraday.response :logger                  # log requests to STDOUT
      		faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    	end
    	profile = conn.get "/#{fb_id}?access_token=#{@@fb_token}"
    	profile = JSON.parse profile.body
    	return User.create(:fb_id => fb_id, :first_name => profile["first_name"], :last_name => profile["last_name"])

	end
end
