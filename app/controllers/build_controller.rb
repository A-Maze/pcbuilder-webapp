require 'json'

class BuildController < ApplicationController
  attr_accessor :products, :requirements, :components, :times_stuck

  def initialize(requirements)
    self.components = Hash.new
    self.requirements = requirements
    self.products = get_products
    self.times_stuck = 0
  end

  def get_products
    products = JSON.parse(Net::HTTP.get(URI.parse(Rails.configuration.api_url + '/product')))
    products.each do |product|
      product['product_schema'] = JSON.parse(product['product_schema'])
    end
  end


  def get_build(product_categories, requirements)
    if requirements
      product_categories = filter(product_categories, requirements)
    end

    first_pick_category = Rails.configuration.build_first_component
    product_categories.each do |product_category|
      if first_pick_category ==  product_category['category_name']
        motherboard = product_category['products'].first
        self.components[first_pick_category] = motherboard
      end
    end

    product_categories.each do |product_category|
      category = product_category['category_name']
      products = product_category['products']

      if self.components[category].nil?
        stuck_at_category = 0
        products.each do |product|
          compatible, not_compatible_at_category = is_compatible(category, product)

          if compatible
            self.components[category] = product
            stuck_at_category = nil
            break
          else
            stuck_at_category = not_compatible_at_category
          end
        end

        if stuck_at_category && times_stuck < 100
          times_stuck += 1
          product_categories = remove_product(stuck_at_category, self.components[stuck_at_category], product_categories)
          self.components.delete(stuck_at_category)

          get_build(product_categories, nil)
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
      return true, nil
    else
      if category == 'motherboard'

        if components['memory']
          if components['memory']['memory_type'] != product['memory_type']
            return false, 'memory'
          end
        end

        if components['case']
          if components['case']['form_factor'] != product['Moederbord formaat']
            return false, 'case'
          end
        end

        if components['cpu']
          if components['cpu']['socket'] != product['socket']
            return false, 'cpu'
          end
        end
      end

      if category == 'memory' && components['motherboard']
        if components['motherboard']['memory_type'] != product['memory_type']
          return false, 'motherboard'
        end
      end

      if category == 'case' && components['motherboard']
        if components['motherboard']['form_factor'] != product['Moederbord formaat']
          return false, 'motherboard'
        end
      end

      if category == 'cpu' && components['motherboard']
        if components['motherboard']['socket'] != product['socket']
          return false, 'motherboard'
        end
      end

      return true, nil
    end
  end

  def remove_product(stuck_at_category, product, product_categories)
    product_categories.each do |product_category|
      category = product_category['category_name']

      if category == stuck_at_category
        product_category['products'].delete_if { |p| p == product }
      end
    end
    product_categories
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

