require 'rspec/its'

RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.syntax = [:should, :expect]
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = [:expect, :should]
    mocks.verify_partial_doubles = true
  end

end
