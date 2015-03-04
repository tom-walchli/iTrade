class AnnEval < ActiveRecord::Base

#
# Class methods
# ================
#

	def self.run()
		str = get_latest_json_string()
		create(results: str)
	end

	def self.get_latest_json_string()
		msmc = IO.read('msmc_key.txt')
		url = "https://msmc-software.com/Arbit/#{msmc}/latestResult.json"
		resp = Net::HTTP.get_response(URI.parse(url))
		return resp.body
	end

#
# Instance methods
# ================
#

 	after_initialize do
 		evaluate()
 	end

	def evaluate()
		buy = false
		buy_confidence = 0
		sell = false

		r = JSON.parse(results)

		if (   r['10']['t_buy_100'] 	> 0.5 \
			&& r['60']['t_buy_101'] 	> 0.5 \
			&& r['600']['t_buy_102'] 	> 0.5 \
			&& r['1800']['t_buy_102'] 	> 0.5 \
			&& r['3600']['t_buy_102'] 	> 0.5 \
			&& r['10']['t_sell_100'] 	< 0.5 \
			&& r['60']['t_sell_100'] 	< 0.5 \
			&& r['600']['t_sell_100'] 	< 0.5 \
			&& r['1800']['t_sell_100'] 	< 0.5 \
			) 
			buy = true
		end

		if (   r['10']['t_sell_100'] 	> 0.5 \
			&& r['60']['t_sell_99'] 	> 0.5 \
			&& r['600']['t_sell_98'] 	> 0.5 \
			&& r['1800']['t_sell_98'] 	> 0.5 \
			&& r['3600']['t_sell_98'] 	> 0.5 \
			&& r['10']['t_sell_100'] 	< 0.5 \
			&& r['60']['t_sell_100'] 	< 0.5 \
			&& r['600']['t_sell_100'] 	< 0.5 \
			&& r['1800']['t_sell_100'] 	< 0.5 \
			)
			sell = true
		end

		buy_confidence  = r['10']['t_buy_100']     	
						+ r['60']['t_buy_101'] 	 
						+ r['600']['t_buy_102']  
						+ r['1800']['t_buy_102'] 
						+ r['3600']['t_buy_102']  # float between 0 and 5


		sell_confidence = r['10']['t_sell_100']  
						+ r['60']['t_sell_99'] 	 
						+ r['600']['t_sell_98']  	
						+ r['1800']['t_sell_98'] 	
						+ r['3600']['t_sell_98']  # float between 0 and 5	

		update_attributes(
			  :buy => buy,
			  :sell => sell,
			  :buy_confidence => buy_confidence,
			  :sell_confidence => sell_confidence)

	end

end
