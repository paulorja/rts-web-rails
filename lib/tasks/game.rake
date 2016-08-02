namespace :game do

  task :resolve_events => :environment do
    Event.all.update_all(end_time: 0)
    puts 'Events resolved'
  end

end
