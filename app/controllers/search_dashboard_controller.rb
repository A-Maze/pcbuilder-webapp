class SearchDashboardController < ApplicationController
	def getSearch
		if params[:zoekterm]
			json = JSON.parse(Net::HTTP.get(URI.parse('http://95.85.12.99:6543/product?searchterm='+params[:zoekterm]+'&limit=100&offset=0&for_sale=true')))
			p json.length

			@products = json[0]['products']
			(1..(json.length-1)).each do |i|
				@products = @products+json[i]['products']
			end
			render json: @products

			#p @products
		end
		
	end

	def getCategory
		p DateTime.strptime("1454535999769",'%s')
		category = JSON.parse(Net::HTTP.get(URI.parse('http://95.85.12.99:6543/category?limit=10')))
		render json: category
	end
end
