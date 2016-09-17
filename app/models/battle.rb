class Battle < ActiveRecord::Base
  belongs_to :user_from, class_name: 'User', foreign_key: :user_from_id
  belongs_to :user_to, class_name: 'User', foreign_key: :user_to_id
  belongs_to :cell

  CELL_SPEED = 300

  def can_attack
    cell_to = Cell.find(cell_to_id)

    return false unless cell_to.have_user_road(user_from_id)
    return false if CellUnit.user_have_idle_army(user_from_id).nil?

    true
  end

  def combat
    parse_battle_data = JSON.parse(battle_data)

    from_armies = group_armies(parse_battle_data['user_from_armies'])
    to_armies = group_armies(user_to.all_armies)
    total_towers = count_towers(parse_battle_data['cells'])

    total_atk = 0.0
    from_armies.each {|f| (total_atk += f[1][:atk].to_f)}

    total_def = 0.0
    to_armies.each {|t| (total_def += t[1][:atk].to_f)}
    total_def = total_def * (1+(total_towers.to_f/10))

    if total_atk > total_def
      pg = total_atk
      pp = total_def

      deaths_ratio = calculate_deaths_ratio(pp, pg)
      from_armies.each do |f|
        f[1][:deaths] = calculate_deaths(f[1][:qtd], deaths_ratio)
        f[1][:hurts] = calculate_hurts(f[1][:qtd], f[1][:deaths])
      end

      to_armies.each do |t|
        t[1][:deaths] = calculate_deaths(t[1][:qtd], 100)
        t[1][:hurts] = calculate_hurts(t[1][:qtd], t[1][:deaths])
      end
    else
      pp = total_atk
      pg = total_def

      deaths_ratio = calculate_deaths_ratio(pp, pg)
      to_armies.each do |t|
        t[1][:deaths] = calculate_deaths(t[1][:qtd], deaths_ratio)
      end

      from_armies.each do |f|
        f[1][:deaths] = calculate_deaths(f[1][:qtd], 100)
      end
    end



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

    def calculate_deaths_ratio(pp, pg)
      100*(pp/pg)**1.5
    end

    def calculate_deaths(qtd, deaths_ratio)
      ((qtd.to_f * (deaths_ratio/100) * 0.33) + 0.25).to_i
    end

    def calculate_hurts(qtd, deaths)
      if deaths == 0
        ((qtd - deaths).to_f * (rand(60).to_f/100)).to_i
      else
        ((qtd - deaths).to_f * (rand(25).to_f/100)).to_i
      end
    end

    def count_towers(cells)
      total_towers = 0

      cells.each {|c| (total_towers += 1 if c['building_code'] == BUILDING[:tower][:code])}

      total_towers
    end

end
