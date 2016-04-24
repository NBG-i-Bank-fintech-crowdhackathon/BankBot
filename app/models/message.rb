require 'open-uri'

class Message < ActiveRecord::Base
	belongs_to :user
	@@fb_token = 'CAAW46Pf7Xo4BANlo4Unadya2BeLtUt3CO5hohlqPbn1ZCrLwbGwKQCdBQrjNFaWp0ilYlt1A4hBKebRuZA0Rai4R1wIfAsMdn3DG0jGoea2iU2frQbCcO25LQ9VEqtqMvdT07G8BbxEAXfBiOqy3NfP12t7rWp0gU7h6hRT9mPSqNfehST1fARJf2oXpBewLwMmuZBKdAZDZD'
	@@ai_token = 'e5e7bff08d9e488e80519a300cc3d9d6'
	@@unknown_count = 0

def range (min, max)
    rand * (max-min) + min
end

def handle_message()
	client = ApiAiRuby::Client.new(
		:client_access_token => @@ai_token,
		:subscription_key => 'YOUR_SUBSCRIPTION_KEY'
		)
	apiresponce = client.text_request text, :contexts => [self.user.state], :sessionId => self.user.fb_id, :resetContexts => self.user.clear_state

	if apiresponce[:result][:action]=='input.unknown' then
		@@unknown_count+=1
		if @@unknown_count>=2 then
			send_info
		end
	else
		@@unknown_count=0
	end

	if apiresponce[:result][:action]=='help' then
		send_info
	elsif  apiresponce[:result][:action]=='nearest_ATM' then
		answer_new('Plase send me your location')
	elsif self.user.pin then
		a=apiresponce[:result][:action]
		if apiresponce[:result][:speech]!='' then
			answer_new(apiresponce[:result][:speech])
		elsif a=='convert' then
			if responce[:result][:parameters][:currency_name_to]=='USD' && responce[:result][:parameters][:unit_currency_from][:currency]=='EUR'
				send_message(user, (1.12235*responce[:result][:parameters][:unit_currency_from][:amount]).to_s + ' '+responce[:result][:parameters][:unit_name_to])
			elsif responce[:result][:parameters][:currency_name_to]=='EUR' && responce[:result][:parameters][:unit_currency_from][:currency]=='USD'
				send_message(user, (0.89098766*responce[:result][:parameters][:unit_currency_from][:amount]).to_s+ ' '+responce[:result][:parameters][:unit_name_to])
			else
				send_message(user, 'I don\'t know the ' )
			end				
		elsif a=='smalltalk.greetings' || a=='smalltalk.agent' then
			send_structured_message
		elsif a=='credit_card_info' then
			answer_new('Loan: 100 EUR\nDue date: 25/4/2016')				
		elsif a=='account_balance' then
			answer_new("Your balance is #{range(100.0, 10000.0).round(2)} EUR")
		elsif a=='last_transactions' then
			answer_new('Last Transactions:')
			answer_new('20/04/2016 19:45:03\ndeposit: 560.00 EUR')
			answer_new('20/04/2016 23:13:13\nwithdraw: 400.00 EUR')
			answer_new('21/04/2016 07:45:57\nwithdraw: 26.78 EUR')
			answer_new('22/04/2016 19:43:34\ndeposit: 100.00 EUR')
		elsif a=='pay_bills' then
			bills = apiresponce[:result][:parameters][:bills]
			answer_new("You have successfully payed your #{bills} bill")
		elsif a=='savings' then
			amount = apiresponce[:result][:parameters][:unit_currency][:amount]
			currency = apiresponce[:result][:parameters][:unit_currency][:currency]
			answer_new("You have successfully salted away #{amount} #{currency}")
		elsif a=='savings_per_month' then
			amount = apiresponce[:result][:parameters][:unit_currency][:amount]
			currency = apiresponce[:result][:parameters][:unit_currency][:currency]
			interval = apiresponce[:result][:parameters][:interval]
			answer_new("From now on you will save #{amount} #{currency} every #{interval}")
		elsif a=='lost_card' then
			item = apiresponce[:result][:parameters][:lost_items]
			answer_new('You have successfully reported a lost '+item)
		elsif a=='lost_password' then
			answer_new('For password recovery follow the link: https://nbgbot.herokuapp.com/passwordrecovery')
		elsif a=='phone_assistance' then
			answer_new('A bank employee will call you soon')
		elsif a=='send_money' then
			amount = apiresponce[:result][:parameters][:unit_currency][:amount]
			currency = apiresponce[:result][:parameters][:unit_currency][:currency]
			iban = apiresponce[:result][:resolvedQuery] scan(/[a-zA-Z]{2}[0-9]{2}[a-zA-Z0-9]{4}[0-9]{7}[a-zA-Z0-9]?{0,16}/)[0]
			answer_new("You have successfully sended #{amount} #{currency} to #{iban}")
		end	
	else
		send_begin()
	end
	# self.user.messages.create(:text=>apiresponce[:result][:speech],:response=>true).send_message
	#puts responce[:result].inspect.gsub('"',"'")

end

def handle_sound()
	client = ApiAiRuby::Client.new(
		:client_access_token => @@ai_token,
		:subscription_key => 'YOUR_SUBSCRIPTION_KEY'
		)
	filename = self.user.fb_id+Time.now.getutc.to_s
	open(filename, 'wb') do |file|
	  file << open(text).read
	end
	# file = File.new filename
	File.delete(filename) if File.exist?(filename)
end

def handle_location(lat, long)
	atm = Atm.within(1000000, :origin => [lat, long] ).order('distance ASC').first
	answer_new( 'Nearest ATM is ' + atm.name + ' at ' + atm.address )
end

def answer_new(text)
	self.user.messages.create(:text=>text,:response=>true).send_message
end

def send_begin()
	conn = Faraday.new(:url => 'https://graph.facebook.com/v2.6') do |faraday|
		faraday.request  :url_encoded             # form-encode POST params
		faraday.response :logger                  # log requests to STDOUT
		faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
	end

	conn.post do |req|
		req.url '/me/messages?access_token=' + @@fb_token
		req.headers['Content-Type'] = 'application/json'
		req.body = "{ \"recipient\": { \"id\" : \"#{self.user.fb_id}\" }, \"message\": { \"attachment\" : {\"type\":\"template\",\"payload\":{\"template_type\":\"button\",\"text\":\"Welcome, in order to begin please authenticate with NBG\",\"buttons\":[{\"type\":\"web_url\",\"title\":\"Authenticate\",\"url\":\"https://nbgbot.herokuapp.com/auth?uid=#{self.user.id}\"}]}} } }"
	end
	puts "{ \"recipient\": { \"id\" : \"#{self.user.fb_id}\" }, \"message\": { \"attachment\" : {\"type\":\"template\",\"payload\":{\"template_type\":\"button\",\"text\":\"Please authenticate with NBG first.\",\"buttons\":[{\"type\":\"web_url\",\"title\":\"Authenticate\",\"url\":\"https://nbgbot.herokuapp.com/auth?uid=#{self.user.id}\"}]}} } }"
end

def send_info()
	conn = Faraday.new(:url => 'https://graph.facebook.com/v2.6') do |faraday|
		faraday.request  :url_encoded             # form-encode POST params
		faraday.response :logger                  # log requests to STDOUT
		faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
	end

	conn.post do |req|
		req.url '/me/messages?access_token=' + @@fb_token
		req.headers['Content-Type'] = 'application/json'
		req.body = "{ \"recipient\": { \"id\" : \"#{self.user.fb_id}\" }, \"message\": { \"attachment\" : {\"type\":\"template\",\"payload\":{\"template_type\":\"button\",\"text\":\"How can i help you ? \",\"buttons\":[{\"type\":\"postback\",\"title\":\"Account balance \",\"payload\":\"Account balance \"},{\"type\":\"postback\",\"title\":\"Nearest ATM ?\",\"payload\":\"ATM ?\"},{\"type\":\"postback\",\"title\":\"Last transcations \",\"payload\":\"Last transcations \"}]}} } }"
	end
	conn.post do |req|
		req.url '/me/messages?access_token=' + @@fb_token
		req.headers['Content-Type'] = 'application/json'
		req.body = "{ \"recipient\": { \"id\" : \"#{self.user.fb_id}\" }, \"message\": { \"attachment\" : {\"type\":\"template\",\"payload\":{\"template_type\":\"button\",\"text\":\"How can i help you ? \",\"buttons\":[{\"type\":\"postback\",\"title\":\"Lost credit card \",\"payload\":\"Lost credit card \"},{\"type\":\"postback\",\"title\":\"I want some help \",\"payload\":\"I want some help \"}]}} } }"
	end
end


def send_message()
	
	conn = Faraday.new(:url => 'https://graph.facebook.com/v2.6') do |faraday|
		faraday.request  :url_encoded             # form-encode POST params
		faraday.response :logger                  # log requests to STDOUT
		faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
	end

	conn.post do |req|
		req.url '/me/messages?access_token=' + @@fb_token
		req.headers['Content-Type'] = 'application/json'
		req.body = "{ \"recipient\": { \"id\" : \"#{self.user.fb_id}\" }, \"message\": { \"text\" : \"#{self.text}\" } }"
	end
end

end
