class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  protect_from_forgery :except => [:handle_message]
  @@fb_token = 'CAAW46Pf7Xo4BANlo4Unadya2BeLtUt3CO5hohlqPbn1ZCrLwbGwKQCdBQrjNFaWp0ilYlt1A4hBKebRuZA0Rai4R1wIfAsMdn3DG0jGoea2iU2frQbCcO25LQ9VEqtqMvdT07G8BbxEAXfBiOqy3NfP12t7rWp0gU7h6hRT9mPSqNfehST1fARJf2oXpBewLwMmuZBKdAZDZD'
  @@ai_token = 'e5e7bff08d9e488e80519a300cc3d9d6'


  def webhook
    if params[:'hub.verify_token'] == 'mglmdsls$432snsbbskk515616adas63432'
      render :text => params[:'hub.challenge']
    else
      render :text => 'Error'
    end
  end

  def handle_message()
    render :text => params
    params[:entry].each do |entry|
      entry[:messaging].each do |message|

        current_user = User.find_by(:fb_id => message[:sender][:id])
        if current_user.blank? then
          current_user = User.create_from_fb(message[:sender][:id].to_s) 
        end

        if(message[:message])
          current_user.messages.create(:text => message[:message][:text], :response => false).handle_message()
        end

      end
    end
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
