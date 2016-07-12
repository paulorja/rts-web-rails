class UserData < ActiveRecord::Base
  belongs_to :user

  def have_recourses(item)
	item_wood = item[:wood].to_i
	item_gold = item[:gold].to_i
	item_stone = item[:stone].to_i
	item_diamond = item[:diamond].to_i

	if wood >= item_wood and stone >= item_stone and gold >= item_gold and diamond >= item_diamond
	  true
	else
	  false
	end
  end

end
