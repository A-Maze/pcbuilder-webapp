require 'net/http'
require 'json'

class HomeController < ApplicationController
  def get_components_structure
    result = Net::HTTP.get(URI.parse('http://95.85.12.99:6543/category'))
    @comps = JSON.parse(result)['categories']

    render json: @comps
  end
end
