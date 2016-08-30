class EventBlacksmith < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  def self.start_event(current_user, up_column)
    item = Blacksmith.get_item(up_column)
    item_level = current_user.user_data[item[:up_column].to_sym]

    return 'Vc está de brincation with me?' unless item
    return 'Nível máximo atingindo' unless item[:levels][item_level+1]
    return 'Você não possui recursos' unless current_user.user_data.have_recourses(item[:levels][item_level+1])
    return 'Ferreiro Ocupado' if EventBlacksmith.where('user_id = ?', current_user.id).count > 0

    item_level = current_user.user_data[item[:up_column].to_sym]

    event = Event.new()
    event.start_time = Time.now.to_i
    event.end_time = Time.now.to_i + item[:levels][item_level+1][:time]
    event.event_type = :blacksmith
    event.save

    EventBlacksmith.create({event_id: event.id, user_id: current_user.id, up_column: up_column})

    current_user.user_data.use_recourses(item[:levels][item_level+1])
  end

  def self.resolve(e)
    event_blacksmith = EventBlacksmith.where('event_id = ?', e.id).first
    user_data = UserData.where('user_id = ?', event_blacksmith.user_id).first
    up_column = event_blacksmith.up_column

    user_data.update_attribute(up_column, user_data[up_column.to_sym]+1)

    e.destroy
    event_blacksmith.destroy
  end
end
