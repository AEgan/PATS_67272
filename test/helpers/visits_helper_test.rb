require 'test_helper'

class VisitsHelperTest < ActionView::TestCase
      context "Given context" do
    # create the objects I want with factories
    setup do 
      @cat = FactoryGirl.create(:animal)
      @alex = FactoryGirl.create(:owner)
      @dusty = FactoryGirl.create(:pet, :animal => @cat, :owner => @alex, :female => false)
      @polo = FactoryGirl.create(:pet, :animal => @cat, :owner => @alex, :name => "Polo")
    end
    
    # and provide a teardown method as well
    teardown do
      @cat.destroy
      @alex.destroy
      @dusty.destroy
      @polo.destroy
    end
  
    # now run the tests:
    # test one of each factory (not really required, but not a bad idea)
    should "the factories were created properly" do
      assert_equal "Alex", @alex.first_name
      assert_equal "Cat", @cat.name
      assert_equal "Dusty", @dusty.name
    end
    
    # test the named scope 'chronological'
    should "get correct visit options array" do
      pets_array = [
        ["#{@dusty.name} (#{@dusty.animal.name}) : #{@dusty.owner.name}", @dusty.id],
        ["#{@polo.name} (#{@polo.animal.name}) : #{@polo.owner.name}", @polo.id]
      ]
      assert_equal pets_array, get_pet_options
    end    
  end
end
