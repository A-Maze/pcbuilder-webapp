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
    products = JSON.parse(Net::HTTP.get(URI.parse(Rails.configuration.api_url + '/product')))
    products.each do |product|
      product['product_schema'] = JSON.parse(product['product_schema'])
    end
  end


  def get_build(product_categories, requirements)
    product_categories = filter(product_categories, requirements)

    product_categories.each do |product_category|
      category = product_category['category_name']
      products = product_category['products']

      products.each do |product|
        if is_compatible(category, product)
          self.components[category] = product
          break
        end
      end
    end

    if self.components.size == self.products.size
      self.components
    else
      nil
    end
  end

  def is_compatible(category, product)
    components = self.components
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

  def filter(products, requirements)
    # For each category get the requirements
    requirements.each do |category, category_requirements|

      # For each category parse the requirements
      JSON.parse(category_requirements).each do |requirement, value|
        # If value not null
        if value

          # For each requirement find other categories having the same field (for example: memory_type -> motherboard and memory)
          products.each do |product_category|

            # For each required field
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

