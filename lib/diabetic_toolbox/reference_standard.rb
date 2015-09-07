module DiabeticToolbox

  # = ReferenceStandard
  #
  # ReferenceStandard provides a table for the daily recommended
  # values for each of the nutrients provided by a typical
  # Nutrition Facts table as shown in {Daily Intake}[http://www.inspection.gc.ca/food/labelling/food-labelling-for-industry/nutrition-labelling/information-within-the-nutrition-facts-table/eng/1389198568400/1389198597278?chap=6]
  #
  # It is assumed that these values are shared in
  # nutritional circles widely.  The following is the usage:
  #
  #   DiabeticToolbox::ReferenceStandard.get(:trans_fat)       # => {:value=>20, :unit=>:grams}
  #   DiabeticToolbox::ReferenceStandard.value_for(:trans_fat) # => 20
  #   DiabeticToolbox::ReferenceStandard.units_for(:trans_fat) # => :grams
  #
  module ReferenceStandard
    #:enddoc:
    @nutrients = {
      fat:          {value: 65,   unit: :grams},
      trans_fat:    {value: 20,   unit: :grams},
      cholesterol:  {value: 300,  unit: :milligrams},
      carbohydrate: {value: 300,  unit: :grams},
      fibre:        {value: 25,   unit: :grams},
      sodium:       {value: 2400, unit: :milligrams},
      vitamin_a:    {value: 1000, unit: :retinol_equivalents},
      vitamin_d:    {value: 5,    unit: :micrograms},
      vitamin_e:    {value: 10,   unit: :milligrams},
      vitamin_c:    {value: 60,   unit: :milligrams},
      vitamin_b1:   {value: 1.3,  unit: :milligrams},
      vitamin_b2:   {value: 1.6,  unit: :milligrams},
      niacin:       {value: 23,   unit: :niacin_equivalents},
      vitamin_b6:   {value: 1.8,  unit: :milligrams},
      folate:       {value: 220,  unit: :micrograms},
      vitamin_b12:  {value: 2,    unit: :micrograms},
      pantothenate: {value: 7,    unit: :milligrams},
      vitamin_k:    {value: 80,   unit: :micrograms},
      biotin:       {value: 30,   unit: :micrograms},
      calcium:      {value: 1100, unit: :milligrams},
      phosphorus:   {value: 1100, unit: :milligrams},
      magnesium:    {value: 250,  unit: :milligrams},
      iron:         {value: 14,   unit: :milligrams},
      zinc:         {value: 9,    unit: :milligrams},
      iodide:       {value: 160,  unit: :micrograms},
      selenium:     {value: 50,   unit: :micrograms},
      copper:       {value: 2,    unit: :milligrams},
      manganese:    {value: 2,    unit: :milligrams},
      chromium:     {value: 120,  unit: :micrograms},
      molybdenum:   {value: 75,   unit: :micrograms},
      chloride:     {value: 3400, unit: :milligrams}
    }

    def self.get(nutrient)
      @nutrients[nutrient]
    end

    def self.value_for(nutrient)
      @nutrients[nutrient][:value]
    end

    def self.units_for(nutrient)
      @nutrients[nutrient][:unit]
    end
  end
end