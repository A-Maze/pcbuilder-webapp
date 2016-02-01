require 'net/http'
require 'json'

class HomeController < ApplicationController
  def get_components_structure
    result = Net::HTTP.get(URI.parse(Rails.configuration.api_url + '/product/filters'))
    @components = JSON.parse(result)

    render json: @components
  end

  def get_build
    requirements = request.query_parameters

    build_controller = BuildController.new(requirements)
    build = build_controller.get_build(build_controller.products, build_controller.requirements)

    if build
      render json: build
    else
      render status: :internal_server_error
    end
  end

  def get_categorie_names
    url = URI.parse(Rails.configuration.api_url + '/category')
    render json: Net::HTTP.get(url)
  end
end
