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

  task :create_map => :environment do
    require './lib/WorldCreation'

    conn = ActiveRecord::Base.connection

    WorldCreation.new(conn)

    puts 'Create map'
  end

  task :reset_server => :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
    Rake::Task['game:create_map'].invoke

    puts 'READY TO PLAY'
  end

end
