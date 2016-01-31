class DashboardController < ApplicationController
  helper_method :comments_as_json
  def index
    #result = Net::HTTP.get(URI.parse('http://95.85.12.99:6543/category'))
    #@components = JSON.parse(result)['categories']

    #@components.each_with_index do |component, index|
    #    @components[index]['product_schema'] = JSON.parse(component['product_schema'])
    #end

    #@product_id = 6

    #url: url/category/{categoryname}/product/{id}

    #voorbeeld voor het verwerken van dynamische url is: 
    #url = 'http://178.62.245.211:6543/category/'+params[:cat_name]+'/product/'+params[:id]
    #json = JSON.parse(Net::HTTP.get(URI.parse('http://178.62.245.211:6543/category/motherboard')))['products']
    

    #p @json

    
    @json_data = JSON.parse(Net::HTTP.get(URI.parse('http://178.62.245.211:6543/category/'+params[:cat_name]+'/product/'+params[:id])))['product']
    
 	p @json_data['name']
 	@product_id = params[:id]
    @value_array = [780, 560, 623, 364, 732, 722, 125, 1542, 473, 102];
    @category_name = params[:cat_name]
  end

  def comments_as_json(comments)
	  Logger.new(STDOUT).info('comments_as_json method loaded')
  end

  def get_build
    p request.query_parameters

    render json: request.query_parameters
  end
end
