module DiabeticToolbox
  # = DiabeticToolbox::IntakeNutrition
  #
  # This class facilitates the ephemeral storage of
  # nutritional values so that unit of measurement
  # and daily value can be determined based on the
  # data provided.
  #
  #   intake_nutrition = IntakeNutrition.new 2 do
  #     add :carbohydrate, 30
  #     add :fat, 15
  #   end
  #
  #   intake_nutrition.daily_value_per_serving :carbohydrate #=> 5.0
  #   intake_nutrition.for :carbohydrate #=> 30
  #
  class IntakeNutrition
    #:enddoc:
    def initialize(servings, &block)
      raise 'Requires block to initialize' unless block_given?

      @nutrients = {}
      @servings  = servings
      instance_eval(&block)
      freeze
    end

    def for(nutrient)
      0 unless @nutrients.has_key? nutrient
      @nutrients[nutrient]
    end

    def daily_value_per_serving(nutrient)
      if @nutrients.has_key? nutrient
        (( (@nutrients[nutrient].to_f / ReferenceStandard.value_for(nutrient).to_f) / @servings ) * 100).round(2)
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