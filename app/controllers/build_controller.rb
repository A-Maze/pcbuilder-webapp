require 'json'

class BuildController < ApplicationController
  attr_accessor :products, :requirements, :components

  def initialize(requirements)
    self.components = Hash.new
    self.requirements = requirements
    self.products = get_products

    get_build(self.products, self.requirements)
  end

  def get_products
    # products = JSON.parse(Net::HTTP.get(URI.parse(Rails.configuration.api_url + '/product')))
    products.each do |product|
      product['product_schema'] = JSON.parse(product['product_schema'])
    end
  end


  def get_build(products, requirements)

    products = filter(products, requirements)

    return products
    requirements.each do |category, requirement|
      products.each_with_index do |product_category, index|
        if product_category['category_name'] == category
          products[index]['products'] = filter_requirements(product_category['products'], requirement)
        end
      end
    end


    products.each do |product_category|
      category = product_category['category_name']
      products = product_category['products']

      i = 0
      loop do
        break if is_compatible(self.components, category, products[i])
        i += 1

        break if i > 10
      end

      self.components[category] = products[i]
    end

    components
  end

  def is_compatible(components, category, product)
    if components.empty?
      true
    else
      if category == 'motherboard'

        if components['memory']
          if components['memory']['memory_type'] != product['memory_type']
            return false
          end
        end

        if components['case']
          if components['case']['form_factor'] != product['Moederbord formaat']
            return false
          end
        end

        if components['cpu']
          if components['cpu']['socket'] != product['socket']
            return false
          end
        end
      end

      if category == 'memory' && components['motherboard']
        if components['motherboard']['memory_type'] != product['memory_type']
          return false
        end
      end

      if category == 'case' && components['motherboard']
        if components['motherboard']['form_factor'] != product['Moederbord formaat']
          return false
        end
      end

      if category == 'cpu' && components['motherboard']
        if components['motherboard']['socket'] != product['socket']
          return false
        end
      end

      # if category == 'video_card' && components.has_key?('motherboard')
      #   return false
      # end

      true
    end
  end

  def filter_requirements(products, requirements)
    JSON.parse(requirements).each do |key, value|
      if value
        products.delete_if { |p| p[key] != value }
      end
    end

    products
  end

  def filter(products, requirements)
    # For each category get the requirements
    requirements.each do |category, category_requirements|

      # For each category parse the requirements
      JSON.parse(category_requirements).each do |requirement, value|
        if value

          # For each requirement find other categorys having the same field (for example: memory_type -> motherboard and memory)
          products.each do |product_category|
            product_category['product_schema']['required'].each do |req|
              if requirement == req
                product_category['products'].delete_if { |p| p[requirement] != value }
              end
            end
          end
        end
      end
    end

    products
  end
end

