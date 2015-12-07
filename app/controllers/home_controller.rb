require 'net/http'
require 'json'

class HomeController < ApplicationController
  def get_components_structure
    result = Net::HTTP.get(URI.parse('http://95.85.12.99:6543/category'))
    @components = JSON.parse(result)['categories']

    @components.each_with_index do |component, index|
        @components[index]['product_schema'] = JSON.parse(component['product_schema'])
    end

    render json: @components
  end

  def get_build
    p request.query_parameters

    render json: request.query_parameters
  end
end
