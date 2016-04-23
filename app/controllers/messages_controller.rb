class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]


  TOKEN = 'CAAY9TEEFWvsBAIeOCZClJ9N5hMS3ZBm0ra4zLKClKL5qx3Nl1sZAOjAZB7wT4ChMXQ71gtVPfyWDhczPIMhPzsGv4n6dFJY71zFWGZChnjnBVArH0dDOm0ee3cktTMVzeDkPjXndeBOSx6pk5dKHa6n5DoZC8u7QEqIBe6WcJ0cnxGTIRJhKU74wWZBrpQbAOnVZBZCaVyMIcvwZDZD'
  SONGS = %w(https://www.youtube.com/watch?v=KaMRuXnAC-E https://www.youtube.com/watch?v=LibY2WDqtl0 https://www.youtube.com/watch?v=N4rlRE6X-y4)
  @@state = ''
  def webhook
    if params[:'hub.verify_token'] == 'eimaioronomanka'
      render :text => params[:'hub.challenge']
    else
      render :text => 'Error'
    end
  end

  def receive_message
    render :text => params
    params[:entry].each do |entry|
      entry[:messaging].each do |message|
        user = message[:sender][:id]
        if(message[:message])
          text = message[:message][:text]
          handle_message(user, text)
        end
      end
    end
  end

  def handle_message(user, text)
    client = ApiAiRuby::Client.new(
        :client_access_token => '83f20082ec39404cbbe3fa6786f63d24',
        :subscription_key => 'YOUR_SUBSCRIPTION_KEY',

    )
    if @@state=='' then
      responce = client.text_request text, :sessionId => user.to_s
    else
      responce = client.text_request text, :contexts => [@@state], :sessionId => user.to_s, :resetContexts => true
    end
    send_message(user, responce[:result].inspect.gsub('"',"'"))
    puts responce[:result].inspect.gsub('"',"'")
    if responce[:result][:speech]!='' then
      send_message(user, responce[:result][:speech])
    elsif responce[:result][:action]=='weed_location' then
      send_message(user, 'I\'ll be there!')
      @@state=''
    elsif responce[:result][:action]=='need_weed' then
      send_message(user, 'I am baking! where?')
      @@state='need_weed_dialog'
    elsif responce[:result][:action]=='convert' then
      puts responce[:result][:parameters]
      puts responce[:result][:parameters][:currency_name_to]
      if responce[:result][:parameters][:currency_name_to]=='USD' && responce[:result][:parameters][:unit_currency_from][:currency]=='EUR'
        send_message(user, (2*responce[:result][:parameters][:unit_currency_from][:amount]).to_s)
      elsif responce[:result][:parameters][:currency_name_to]=='EUR' && responce[:result][:parameters][:unit_currency_from][:currency]=='USD'
        send_message(user, (responce[:result][:parameters][:unit_currency_from][:amount]/2).to_s)
      else
        send_message(user, 'only EUR and USD please')
      end
    elsif responce[:result][:action]=='send_song' then
      send_message(user, SONGS.sample)
    elsif responce[:result][:action]=='reserve' then
      send_message(user, "sorry, I will be at tirana on #{responce[:result][:parameters][:date]}, #{responce[:result][:parameters][:time]}")
    else
      send_message(user, 'else '+responce[:result][:speech])
    end
  end

  def send_message(user, message)
    puts user
    puts message
    conn = Faraday.new(:url => 'https://graph.facebook.com/v2.6') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    conn.post do |req|
      req.url '/me/messages?access_token=' + TOKEN
      req.headers['Content-Type'] = 'application/json'
      req.body = "{ \"recipient\": { \"id\" : \"#{user}\" }, \"message\": { \"text\" : \"#{message}\" } }"
    end
    #puts "{ \"recipient\": { \"id\" : \"#{user}\" }, \"message\": { \"text\" : \"#{message}\" } }"
  end

  
  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:user_id, :text, :response)
    end
end
