require 'net/http'
require 'json'

class HomeController < ApplicationController
  def get_components_structure
    result = Net::HTTP.get(URI.parse('http://95.85.12.99:6543/category'))
    @components = JSON.parse(result)['categories']

    @components.each_with_index do |component, index|
        @components[index]['product_schema'] = {"type": ['ssd', 'hdd'],"size": ['250gb', '500gb', '1tb']} # temporarily json object (mock)
    end

    render json: @components
  end

  def get_build
    requirements = request.query_parameters
    builder = BuildController.new(requirements)

    render json: builder.get_build
  end
end
