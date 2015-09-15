module DiabeticToolbox
  class IntakeNutrition
    def initialize(&block)
      raise 'Requires block to initialize' unless block_given?

      @nutrients = {}
      instance_eval(&block)
      freeze
    end

    def for(nutrient)
      0 unless @nutrients.has_key? nutrient
      @nutrients[nutrient]
    end

    def daily_value_per_serving(nutrient)
      if @nutrients.has_key? nutrient
        ((@nutrients[nutrient].to_f / ReferenceStandard.value_for(nutrient).to_f) * 100).round(2)
      end
    end

    protected
    def add(nutrient, quantity)
      @nutrients[nutrient] = quantity if nutrient_valid? nutrient, quantity
    end

    private
    def nutrient_valid?(nutrient, quantity)
      true if ReferenceStandard.valid_nutrient?(nutrient) && quantity.is_a?( Numeric )
    end
  end
end