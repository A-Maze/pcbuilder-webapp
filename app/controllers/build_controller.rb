require 'json'

class BuildController < ApplicationController
  attr_accessor :products, :requirements, :components

  def initialize(requirements)
    self.components = Hash.new
    self.requirements = requirements
    self.products = JSON.parse(File.read(Rails.root.join('app', 'assets', 'javascripts', 'products.json'))) # get_all_products

    get_build(self.products, self.requirements)
  end

  def get_all_products
    _ = {"memory" => JSON.parse(Net::HTTP.get(URI.parse(Rails.configuration.api_url + '/category/memory')))['products']},
        { "motherboard" => JSON.parse(Net::HTTP.get(URI.parse(Rails.configuration.api_url + '/category/motherboard')))['products']},
        { "hard_drive" => JSON.parse(Net::HTTP.get(URI.parse(Rails.configuration.api_url + '/category/hard_drive')))['products']},
        { "cooler" => JSON.parse(Net::HTTP.get(URI.parse(Rails.configuration.api_url + '/category/cooler')))['products']},
        { "case" => JSON.parse(Net::HTTP.get(URI.parse(Rails.configuration.api_url + '/category/case')))['products']},
        { "cpu" => JSON.parse(Net::HTTP.get(URI.parse(Rails.configuration.api_url + '/category/cpu')))['products']},
        { "video_card" => JSON.parse(Net::HTTP.get(URI.parse(Rails.configuration.api_url + '/category/video_card')))['products']},
        { "optical_drive" => JSON.parse(Net::HTTP.get(URI.parse(Rails.configuration.api_url + '/category/optical_drive')))['products']},
        { "power_supply" => JSON.parse(Net::HTTP.get(URI.parse(Rails.configuration.api_url + '/category/power_supply')))['products']}
  end

  def get_build(products, requirements)
    requirements.each do |category, requirement|
      products.each_with_index do |p, index|
        if p.first.first == category
          products[index] = filter_requirements(p, requirement)
        end
      end
    end

    products.each do |category|
      cat, products = category.first

      i = 0
      loop do
        break if is_compatible(self.components, cat, products[i])
        i += 1

        break if i > 10
      end

      self.components[cat] = products[i]
    end

    components
  end

  def is_compatible(components, category, product)
    if components.empty?
      return true
    else
      if category == 'motherboard' && components['memory']['memory_type'] != product['memory_type']
        return false
      end

      if category == 'case' && components['motherboard']['form_factor'] != product['Moederbord formaat']
        return false
      end

      if category == 'cpu' && components['motherboard']['socket'] != product['socket']
        return false
      end

      # if category == 'video_card' && components.has_key?('motherboard')
      #   return false
      # end

      true
    end
  end

  def filter_requirements(products, requirements)
    JSON.parse(requirements).each do |key, value|
      products.values[0].delete_if { |p| p[key] != value }
    end

    products
  end
end

