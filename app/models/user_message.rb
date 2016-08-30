class UserMessage < ActiveRecord::Base
  belongs_to :from_user, class_name: 'User', foreign_key: :from_user_id
  belongs_to :to_user, class_name: 'User', foreign_key: :to_user_id

  def self.send_message(current_user, m_params)
    to_user = User.find_by_login(m_params[:login])

    return 'Jogador não encontrado' if to_user.nil?

    msg = UserMessage.new

    msg.from_user_id = current_user.id
    msg.to_user_id = to_user.id
    msg.title = m_params[:title]
    msg.body = m_params[:body]

    unless msg.save
      return 'Erro'
    else
      to_user.user_data.update_attribute(:new_message, to_user.user_data.new_message+1)
    end
  end

end
