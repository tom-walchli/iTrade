namespace :ann_eval do

  task do_stuff: :environment do
    # Delete any previously-scheduled recurring jobs
    # Delayed::Job.where('(handler LIKE ?)', '--- !ruby/object:Recurring::%').destroy_all
    loop do
    	AnnEval.run()
    	sleep(6)
    end
  end
end
