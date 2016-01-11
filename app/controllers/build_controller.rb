require 'json'

class BuildController < ApplicationController
  attr_accessor :products, :requirements, :components

  def initialize(requirements)
    self.components = Hash.new
    self.requirements = requirements
    self.products = get_all_products
    get_build(self.products, self.requirements)
  end

  def get_all_products
    _ = {"memory" => JSON.parse(Net::HTTP.get(URI.parse('http://localhost:6543/category/memory')))['products']},
        { "motherboard" => JSON.parse(Net::HTTP.get(URI.parse('http://localhost:6543/category/motherboard')))['products']},
        { "hard_drive" => JSON.parse(Net::HTTP.get(URI.parse('http://localhost:6543/category/hard_drive')))['products']},
        { "cooler" => JSON.parse(Net::HTTP.get(URI.parse('http://localhost:6543/category/cooler')))['products']},
        { "case" => JSON.parse(Net::HTTP.get(URI.parse('http://localhost:6543/category/case')))['products']},
        { "cpu" => JSON.parse(Net::HTTP.get(URI.parse('http://localhost:6543/category/cpu')))['products']},
        { "video_card" => JSON.parse(Net::HTTP.get(URI.parse('http://localhost:6543/category/video_card')))['products']},
        { "optical_drive" => JSON.parse(Net::HTTP.get(URI.parse('http://localhost:6543/category/optical_drive')))['products']}
  end

  def get_build(products, requirements)
    # for each category the requirement
    requirements.each do |key, req|
      p "filter for: " + key

      # key == category
      products[key] = filter_requirements(key, req)
    end

    j = 0
    products.each do |category|
      cat, products = category.first

      i = 0
      loop do
        break if is_compatible(self.components, cat, products[i])
        i += 1

        break if i > 10
      end

      self.components[cat] = products[i]

      break if j > 10
    end

    return products

    # pro

    # for each product category is compatatible?
  end

  def is_compatible(components, category, product)
    if components.empty?
      return true
    else
      if category == 'motherboard' && components['memory']['memory_type'] != product['memory_type']
        return false
      end

      if category == 'case' && components['motherboard']['form_factor'] != product['form_factor']
        return false
      end

      # if category == 'video_card' && components.has_key?('motherboard')
      #   return false
      # end

      if category == 'cpu' && components['cpu']['socket'] != product['socket']
        return true
      end
    end
  end

  def filter_requirements(category, requirements)
    requirements.each do |key, req|
      # if key != req @category remove from products
    end
  end
end

