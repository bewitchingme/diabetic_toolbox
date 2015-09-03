RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    begin
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with :truncation

      DatabaseCleaner.start
      DatabaseCleaner.clean
      FactoryGirl.lint
    end
  end
end