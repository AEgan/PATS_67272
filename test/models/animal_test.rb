require 'test_helper'

class AnimalTest < ActiveSupport::TestCase
  # Not much for testing Animal as it is a simple model
  # Relationship matchers...
  should have_many(:pets)
  should have_many(:vaccines)
  
  # Validation matchers...
  should validate_presence_of(:name)
end
