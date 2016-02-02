require 'net/http'
require 'json'

class HomeController < ApplicationController
  def get_components_structure
    result = Net::HTTP.get(URI.parse(Rails.configuration.api_url + '/product/filters'))
    components = JSON.parse(result)

    JSON.parse(get_categorie_names)['categories'].each do |category|
      components.each do |component|
        if component['category'] == category['name']
          component['name'] = category['locale']['nl_NL']
        end
      end
    end

    render json: components
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
    Net::HTTP.get(url).as_json
  end
end
