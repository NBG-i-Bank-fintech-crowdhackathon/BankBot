class Message < ActiveRecord::Base
	belongs_to :user
	@@fb_token = 'CAAW46Pf7Xo4BANlo4Unadya2BeLtUt3CO5hohlqPbn1ZCrLwbGwKQCdBQrjNFaWp0ilYlt1A4hBKebRuZA0Rai4R1wIfAsMdn3DG0jGoea2iU2frQbCcO25LQ9VEqtqMvdT07G8BbxEAXfBiOqy3NfP12t7rWp0gU7h6hRT9mPSqNfehST1fARJf2oXpBewLwMmuZBKdAZDZD'
    @@ai_token = 'e5e7bff08d9e488e80519a300cc3d9d6'
def handle_message()
	client = ApiAiRuby::Client.new(
		:client_access_token => @@ai_token,
		:subscription_key => 'YOUR_SUBSCRIPTION_KEY',
		)
	self.send_message( "Hi" )
	#puts responce[:result].inspect.gsub('"',"'")

end

def send_message(message)
	
	conn = Faraday.new(:url => 'https://graph.facebook.com/v2.6') do |faraday|
  		faraday.request  :url_encoded             # form-encode POST params
  		faraday.response :logger                  # log requests to STDOUT
  		faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
	end

	conn.post do |req|
		req.url '/me/messages?access_token=' + @@fb_token
		req.headers['Content-Type'] = 'application/json'
		req.body = "{ \"recipient\": { \"id\" : \"#{user}\" }, \"message\": { \"text\" : \"#{message}\" } }"
	end
#puts "{ \"recipient\": { \"id\" : \"#{user}\" }, \"message\": { \"text\" : \"#{message}\" } }"
end

end
