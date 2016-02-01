class SearchDashboardController < ApplicationController
	def getSearch
		if params[:zoekterm]
			json = JSON.parse(Net::HTTP.get(URI.parse('http://178.62.245.211:6543/product?searchterm='+params[:zoekterm])))
			p json.length

			@products = json[0]['products']
			(1..(json.length-1)).each do |i|
				@products = @products+json[i]['products']
			end
			render json: @products

			#p @products
		end
		
	end

	def get_id(id)
		@idConverted = id
		@idConverted = @idConverted['$oid']
		return @idConverted
	end

	def get_category(category)
		@categoryConverted = category
		if(@categoryConverted == 'CPU-koelers')
			@categoryConverted = 'cooler'
		end
		return @categoryConverted
	end
end
