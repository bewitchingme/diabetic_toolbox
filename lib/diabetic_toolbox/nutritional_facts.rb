module DiabeticToolbox
  class NutritionalFacts
    attr_accessor :fat, :trans_fat, :cholesterol, :carbohydrate,
                  :fibre, :sodium, :potassium, :vitamin_a, :vitamin_d,
                  :vitamin_e, :vitamin_c, :vitamin_b1, :vitamin_b2,
                  :niacin, :vitamin_b6, :folate, :vitamin_b12, :pantothenate,
                  :vitamin_k, :biotin, :calcium, :phosphorus, :magnesium,
                  :iron, :zinc, :iodide, :selenium, :copper, :manganese,
                  :chromium, :molybdenum, :chloride

    def initialize(&block)
      raise 'Requires block to initialize' unless block_given?
      instance_eval(&block)
      freeze
    end

    protected
    def add(content, quantity_in_grams)
      self.send "#{content.to_s}=", quantity_in_grams
    end
  end
end