class MessageController < ApplicationController

  def index
    @messages = UserMessage.where('to_user_id = ?', @current_user.id)

  end

  def sent
    @messages = UserMessage.where('from_user_id = ?', @current_user.id)
  end

  def detail
    @message = UserMessage.find(params[:id])

    if @message.from_user_id != @current_user.id and @message.to_user_id != @current_user.id
      redirect_to :back
    end

    if !@message.read and @current_user.id == @message.to_user_id
      @message.update_attribute(:read, true)
      @user_data.update_attribute(:new_message, @user_data.new_message-1)
    end
  end

  def new

  end

  def post_new
    message = UserMessage.send_message(@current_user, {login: params[:user_login], title: params[:title], body: params[:body]})

    if message.is_a? String
      flash[:alert] = message
    else
      flash[:notice] = 'Mensagem Enviada'
    end

    redirect_to :back
  end


end
