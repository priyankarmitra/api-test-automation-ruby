# frozen_string_literal: true

require "minitest/spec"

#API Specifics
require "json"

# Enables making the MinitTest::Assertions available in the step definitions
class MinitestWorld
  include Minitest::Assertions
  attr_accessor :assertions

  def initialize
    self.assertions = 0
  end
end

World do
  MinitestWorld.new
end
