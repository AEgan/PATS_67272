require 'test_helper'

class VaccinationsHelperTest < ActionView::TestCase
    context "Given context" do
    # create the objects I want with factories
    setup do 
      @cat = FactoryGirl.create(:animal)
      @rabies = FactoryGirl.create(:vaccine, :name => "Rabies", :animal => @cat)
      @leukemia = FactoryGirl.create(:vaccine, :animal => @cat, :duration => nil)
      @alex = FactoryGirl.create(:owner)
      @dusty = FactoryGirl.create(:pet, :animal => @cat, :owner => @alex, :female => false)
      @polo = FactoryGirl.create(:pet, :animal => @cat, :owner => @alex, :name => "Polo")
      @visit1 = FactoryGirl.create(:visit, :pet => @dusty)
      @visit2 = FactoryGirl.create(:visit, :pet => @polo, :date => 5.months.ago.to_date)
      @visit3 = FactoryGirl.create(:visit, :pet => @polo, :date => 3.months.ago.to_date)
      @vacc1 = FactoryGirl.create(:vaccination, :visit => @visit1, :vaccine => @leukemia)
      @vacc2 = FactoryGirl.create(:vaccination, :visit => @visit2, :vaccine => @rabies)
      @vacc3 = FactoryGirl.create(:vaccination, :visit => @visit2, :vaccine => @leukemia)
      @vacc4 = FactoryGirl.create(:vaccination, :visit => @visit3, :vaccine => @leukemia)
    end
    
    # and provide a teardown method as well
    teardown do
      @cat.destroy
      @rabies.destroy
      @leukemia.destroy
      @alex.destroy
      @dusty.destroy
      @polo.destroy
      @visit1.destroy
      @visit2.destroy
      @visit3.destroy
      @vacc1.destroy
      @vacc2.destroy
      @vacc3.destroy
      @vacc4.destroy
    end
  
    # now run the tests:
    # test one of each factory (not really required, but not a bad idea)
    should "the factories were created properly" do
      assert_equal "Alex", @alex.first_name
      assert_equal "Cat", @cat.name
      assert_equal "Dusty", @dusty.name
      assert_equal "Rabies", @rabies.name
      assert_equal 5, @visit1.weight
      assert_equal "250 ml", @vacc1.dosage
    end
    
    # test the named scope 'chronological'
    should "get correct visit options array" do
      visits_array = [
        ["#{@visit3.date.strftime("%m/%d/%y")} : #{@visit3.pet.name} (#{@visit3.pet.animal.name})", @visit3.id],
        ["#{@visit2.date.strftime("%m/%d/%y")} : #{@visit2.pet.name} (#{@visit2.pet.animal.name})", @visit2.id],
        ["#{@visit1.date.strftime("%m/%d/%y")} : #{@visit1.pet.name} (#{@visit1.pet.animal.name})", @visit1.id]
      ]
      assert_equal visits_array, get_visit_options
    end

    should "get correct vaccine options array" do
      vaccines_array = [
        ["#{@leukemia.name} : #{@leukemia.animal.name}",@leukemia.id],
        ["#{@rabies.name} : #{@rabies.animal.name}", @rabies.id]
      ]
      assert_equal vaccines_array, get_vaccine_options
    end    
  end
end
