class Message < ActiveRecord::Base
	belongs_to :user
	
def handle_message()
	client = ApiAiRuby::Client.new(
		:client_access_token => config.ai_token,
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
		req.url '/me/messages?access_token=' + config.fb_token
		req.headers['Content-Type'] = 'application/json'
		req.body = "{ \"recipient\": { \"id\" : \"#{user}\" }, \"message\": { \"text\" : \"#{message}\" } }"
	end
#puts "{ \"recipient\": { \"id\" : \"#{user}\" }, \"message\": { \"text\" : \"#{message}\" } }"
end

end
