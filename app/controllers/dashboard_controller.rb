class DashboardController < ApplicationController
  def getData
    json_data = JSON.parse(Net::HTTP.get(URI.parse('http://95.85.12.99:6543/category/'+params[:cat_name]+'/product/'+params[:id])))['product']
    render json: json_data
  end
end
