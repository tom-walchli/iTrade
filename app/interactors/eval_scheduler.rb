class EvalScheduler
  include Delayed::RecurringJob
  run_every 6.seconds
  queue 'slow-jobs'
  def perform
  	AnnEval.run()
  end
end