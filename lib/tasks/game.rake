namespace :game do

  task :resolve_events => :environment do
    Event.all.update_all(end_time: 0)
    puts 'Events resolved'
  end

  task :rec9999 => :environment do
    UserData.update_all({
      wood: 9999,
      gold: 9999,
      food: 9999,
      stone: 9999
    })

    puts '9999 recourses to all users'
  end

end
