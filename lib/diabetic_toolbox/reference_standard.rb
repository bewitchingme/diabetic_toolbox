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
  #   DiabeticToolbox::ReferenceStandard.get(:trans_fat)            # => {:value=>20, :unit=>:gram}
  #   DiabeticToolbox::ReferenceStandard.value_for(:trans_fat)      # => 20
  #   DiabeticToolbox::ReferenceStandard.units_for(:trans_fat)      # => :gram
  #   DiabeticToolbox::ReferenceStandard.valid_nutrient? :trans_fat # => true
  #   DiabeticToolbox::ReferenceStandard.nutrients                  # => [:fat, :trans_fat, ...]
  #
  module ReferenceStandard
    #:enddoc:
    #region Data Table
    @nutrients = {
      fat:          {value: 65,   unit: :gram},
      trans_fat:    {value: 20,   unit: :gram},
      cholesterol:  {value: 300,  unit: :milligram},
      carbohydrate: {value: 300,  unit: :gram},
      fibre:        {value: 25,   unit: :gram},
      sodium:       {value: 2400, unit: :milligram},
      vitamin_a:    {value: 1000, unit: :retinol_equivalent},
      vitamin_d:    {value: 5,    unit: :microgram},
      vitamin_e:    {value: 10,   unit: :milligram},
      vitamin_c:    {value: 60,   unit: :milligram},
      vitamin_b1:   {value: 1.3,  unit: :milligram},
      vitamin_b2:   {value: 1.6,  unit: :milligram},
      niacin:       {value: 23,   unit: :niacin_equivalent},
      vitamin_b6:   {value: 1.8,  unit: :milligram},
      folate:       {value: 220,  unit: :microgram},
      vitamin_b12:  {value: 2,    unit: :microgram},
      pantothenate: {value: 7,    unit: :milligram},
      vitamin_k:    {value: 80,   unit: :microgram},
      biotin:       {value: 30,   unit: :microgram},
      calcium:      {value: 1100, unit: :milligram},
      phosphorus:   {value: 1100, unit: :milligram},
      magnesium:    {value: 250,  unit: :milligram},
      iron:         {value: 14,   unit: :milligram},
      zinc:         {value: 9,    unit: :milligram},
      iodide:       {value: 160,  unit: :microgram},
      selenium:     {value: 50,   unit: :microgram},
      copper:       {value: 2,    unit: :milligram},
      manganese:    {value: 2,    unit: :milligram},
      chromium:     {value: 120,  unit: :microgram},
      molybdenum:   {value: 75,   unit: :microgram},
      chloride:     {value: 3400, unit: :milligram},
      protein:      {value: 51,   unit: :gram}
    }
    #endregion

    #region Methods
    def self.nutrients
      @nutrients
    end

    def self.valid_nutrient?(nutrient)
      true if @nutrients.keys.include? nutrient
    end

    def self.get(nutrient)
      @nutrients[nutrient]
    end

    def self.value_for(nutrient)
      @nutrients[nutrient][:value]
    end

    def self.units_for(nutrient)
      @nutrients[nutrient][:unit]
    end
    #endregion
  end
end