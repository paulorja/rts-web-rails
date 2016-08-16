namespace :game do

  task :resolve_events => :environment do
    Event.all.update_all(end_time: 0)
    puts 'Events resolved'
  end

  task :rec999 => :environment do
    UserData.update_all({
      wood: 999999,
      gold: 999999,
      food: 999999,
      stone: 999999
    })

    puts '9999 recourses to all users'
  end

end
