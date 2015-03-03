class AnnEval < ActiveRecord::Base

	@running = false
	def self.kickoff()
		@running = true
		run()
	end

	def self.run()
		get_latest_json()
	end

	def self.get_latest_json()
		url = "https://msmc-software.com/Arbit/abcd/latestResult.json"
		resp = Net::HTTP.get_response(URI.parse(url))
		puts "==========================================="
		puts resp
		puts "==========================================="

	end

end
