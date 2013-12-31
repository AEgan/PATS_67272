require 'test_helper'

class FactoryTest < ActiveSupport::TestCase
  # A simple method to test all our factories, but NOTE that it 
  # will fail if the association must exist in advance and be active
  # Commenting out for now and will discuss in class...
  # context "Building factories" do
  #   FactoryGirl.factories.map(&:name).each do |factory_name|
  #     should "create a valid #{factory_name} factory" do
  #       assert FactoryGirl.build(factory_name.to_s).valid?
  #     end
  #   end
  # end 
end