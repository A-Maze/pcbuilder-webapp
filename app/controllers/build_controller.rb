require 'json'

class BuildController < ApplicationController
  attr_accessor :products, :requirements, :components, :offset, :limit, :times_stuck

  def initialize(requirements)
    self.components = Hash.new
    self.requirements = requirements
    self.offset = 0
    self.limit = 2
    self.products = get_products
    self.times_stuck = 0
  end

  def get_products
    params = {'limit' => self.limit, 'offset' => self.offset}#, 'for_sale' => false}
    url = Rails.configuration.api_url + '/product?' + URI.encode_www_form(params)

    products = JSON.parse(Net::HTTP.get(URI.parse(url)))
    products.each do |product|
      product['product_schema'] = JSON.parse(product['product_schema'])
    end
  end

  def get_build(product_categories, requirements)
    if requirements
      i = 0
      while i < 100
        i += 1
        product_categories = filter(product_categories, requirements)

        empty_category = get_empty_product_categories(product_categories)
        break if empty_category.nil?

        product_categories.each_with_index do |product_category, index|
          if product_category['category_name'] == empty_category['category_name']
            product_categories[index] = add_products(empty_category)
          end
        end
        p 'hoi'
      end
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
          self.times_stuck += 1
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
        if components['motherboard']['form_factor'] != product['form_factor']
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

  def get_empty_product_categories(product_categories)
    product_categories.each do |category|
      if category['products'].size == 0
        return category
      end
    end
    nil
  end

  def add_products(product_category)
    self.offset += 2

    params = {'limit' => self.limit, 'offset' => self.offset}#, 'for_sale' => false}
    url = Rails.configuration.api_url + '/category/' + product_category['category_name'] + '?' + URI.encode_www_form(params)

    product_category = JSON.parse(Net::HTTP.get(URI.parse(url)))
    product_category['product_schema'] = JSON.parse(product_category['product_schema'])
    product_category['category_name'] = product_category['name']
    product_category
  end
end

