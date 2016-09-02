class Battle < ActiveRecord::Base
  belongs_to :user_from, class_name: 'User', foreign_key: :user_from_id
  belongs_to :user_to, class_name: 'User', foreign_key: :user_to_id
  belongs_to :cell


  def can_attack
    cell_to = Cell.find(cell_to_id)

    return false unless cell_to.have_user_road(user_from_id)
    return false if CellUnit.user_have_idle_army(user_from_id).nil?

    true
  end

end
