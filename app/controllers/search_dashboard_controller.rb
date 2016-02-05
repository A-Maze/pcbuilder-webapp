class SearchDashboardController < ApplicationController
	def getSearch
		if params[:zoekterm]
			json = JSON.parse(Net::HTTP.get(URI.parse('http://95.85.12.99:6543/product?searchterm='+params[:zoekterm]+'&limit=100&offset=0&for_sale=true')))
			render json: json
		end
		
	end
end
