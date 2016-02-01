require 'net/http'
require 'json'

class HomeController < ApplicationController
  def get_components_structure
    # result = Net::HTTP.get(URI.parse(Rails.configuration.api_url + '/category/filter'))
    result = File.read(Rails.root.join('app', 'assets', 'javascripts', 'filters.json'))
    @components = JSON.parse(result)

    render json: @components
  end

  def get_build
    requirements = request.query_parameters

    build = BuildController.new(requirements)
    render json: build.get_build(build.products, build.requirements)
  end
end
