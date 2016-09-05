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

  def combat
    self.step += 1

    parse_battle_data = JSON.parse(battle_data)

    from_armies = group_armies(parse_battle_data['user_from_armies'])
    to_armies = group_armies(user_to.all_armies)



    self.save
  end

  def finish
    self.save
  end

  private
    def group_armies armies
      group_armies = {}

      armies.each do |a|
        unless a['hurt']
          group_armies[a['unit'].to_s] = {} if group_armies[a['unit'].to_s].nil?

          if group_armies[a['unit'].to_s][:atk].nil?
            group_armies[a['unit'].to_s][:atk] = a['attack']
          else
            group_armies[a['unit'].to_s][:atk] += a['attack']
          end

          if group_armies[a['unit'].to_s][:qtd].nil?
            group_armies[a['unit'].to_s][:qtd] = 1
          else
            group_armies[a['unit'].to_s][:qtd] += 1
          end
        end
      end

      group_armies
    end

end
