require 'net/http'
require 'json'

class HomeController < ApplicationController
  def get_components_structure
    result = Net::HTTP.get(URI.parse('http://95.85.12.99:6543/category'))
    @components = JSON.parse(result)['categories']

    @components.each_with_index do |component, index|
      if index != 3
        @components[index]['product_schema'] = JSON.parse(component['product_schema'])
      end
    end

    render json: @components
  end
end
