class BuildController < ApplicationController
  attr_accessor :products, :requirements

  def initialize(requirements)
    @requirements = requirements
    @products = get_all_products
  end

  def get_all_products
    # code here
  end

  def get_build
    requirements.each do |key, req|
      filter_requirements(key, req)
    end

    # for each product category is compatatible?
  end

  def filter_requirements(category, requirements)
    requirements.each do |key, req|
      # if key != req @category remove from products
    end
  end
end

