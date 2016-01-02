class BuildController < ApplicationController
  def initialize(requirements)
    requirements.each do |key, req|
      get_products(key, req)
    end
  end

  def get_products(category, requirements)
    p category
    # http get products
  end
end

