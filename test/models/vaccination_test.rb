require 'test_helper'

class VaccinationTest < ActiveSupport::TestCase
  # Start by using ActiveRecord macros
  # Relationship macros...
  should belong_to(:visit)
  should belong_to(:vaccine)


  # ---------------------------------
  # Testing other methods with a context
  context "Given context" do
    # create the objects I want with factories
    setup do 
      @cat = FactoryGirl.create(:animal)
      @dog = FactoryGirl.create(:animal, :name => "Dog")
      @rabies = FactoryGirl.create(:vaccine, :name => "Rabies", :animal => @cat)
      @leukemia = FactoryGirl.create(:vaccine, :animal => @cat, :duration => nil)
      @heartworm = FactoryGirl.create(:vaccine, :name => "Heartworm", :animal => @dog)
      @alex = FactoryGirl.create(:owner)
      @mark = FactoryGirl.create(:owner, :first_name => "Mark")
      @dusty = FactoryGirl.create(:pet, :animal => @cat, :owner => @alex, :female => false)
      @polo = FactoryGirl.create(:pet, :animal => @cat, :owner => @alex, :name => "Polo")
      @pork_chop = FactoryGirl.create(:pet, :animal => @dog, :owner => @mark, :name => "Pork Chop")
      @bama = FactoryGirl.create(:pet, :animal => @cat, :owner => @alex, :name => "Bama")
      @visit1 = FactoryGirl.create(:visit, :pet => @dusty)
      @visit2 = FactoryGirl.create(:visit, :pet => @polo, :date => 5.months.ago.to_date)
      @visit3 = FactoryGirl.create(:visit, :pet => @polo, :date => 3.months.ago.to_date)
      @visit4 = FactoryGirl.create(:visit, :pet => @bama, :date => 2.months.ago.to_date)
      @vacc1 = FactoryGirl.create(:vaccination, :visit => @visit1, :vaccine => @leukemia)
      @vacc2 = FactoryGirl.create(:vaccination, :visit => @visit2, :vaccine => @rabies)
      @vacc3 = FactoryGirl.create(:vaccination, :visit => @visit2, :vaccine => @leukemia)
      @vacc4 = FactoryGirl.create(:vaccination, :visit => @visit3, :vaccine => @leukemia)
      @vacc5 = FactoryGirl.create(:vaccination, :visit => @visit4, :vaccine => @rabies)
    end
    
    # and provide a teardown method as well
    teardown do
      @cat.destroy
      @dog.destroy
      @rabies.destroy
      @leukemia.destroy
      @heartworm.destroy
      @alex.destroy
      @mark.destroy
      @dusty.destroy
      @polo.destroy
      @pork_chop.destroy
      @bama.destroy
      @visit1.destroy
      @visit2.destroy
      @visit3.destroy
      @visit4.destroy
      @vacc1.destroy
      @vacc2.destroy
      @vacc3.destroy
      @vacc4.destroy
      @vacc5.destroy
    end
  
    # now run the tests:
    # test one of each factory (not really required, but not a bad idea)
    should "show that cat, owner, pet, vaccine, visit is created properly" do
      assert_equal "Alex", @alex.first_name
      assert_equal "Cat", @cat.name
      assert_equal "Dusty", @dusty.name
      assert_equal "Rabies", @rabies.name
      assert_equal 5, @visit1.weight
      assert_equal "250 ml", @vacc1.dosage
    end
    
    # test the named scope 'chronological'
    should "list vaccinations in chronological order" do
      assert_equal 5, Vaccination.chronological.size # quick check of size
      dates = Array.new
      # get array of visit dates in order
      [2,3,5,5,6].sort.each {|n| dates << n.months.ago.to_date}
      assert_equal dates, Vaccination.chronological.map{|v| v.visit.date}
    end
    
    # test the named scope 'for_visit'
    should "have named scope for_visit that works" do
      assert_equal 1, Vaccination.for_visit(@visit1.id).size
      assert_equal 2, Vaccination.for_visit(@visit2.id).size
    end
    
    # test the named scope 'for_vaccine'
    should "have named scope called for_visit that works" do
      assert_equal 3, Vaccination.for_vaccine(@leukemia.id).size
      assert_equal 2, Vaccination.for_vaccine(@rabies.id).size
    end
    
    # test the custom validation 'vaccine_offered_by_PATS'
    should "identify a vaccine not offered at PATS as invalid" do
      # using 'build' instead of 'create' so not added to db; vaccine will not be in the system (only in memory)
      @catnip = FactoryGirl.build(:vaccine, :name => "Catnippititus", :animal => @cat)
      catnip_vaccination = FactoryGirl.build(:vaccination, :visit => @visit1, :vaccine => @catnip)
      deny catnip_vaccination.valid?
      # already tested valid vaccinations, so only test the bad cases are kept out here...
    end
    
    # test the custom validation 'vaccine_matches_animal_type'
    should "not allow vaccines that are inappropriate to the animal" do
      # Testing both parts of the validation this time for demo purposes...
      # create a visit for Pork Chop (dog)
      @visit_pork_chop = FactoryGirl.create(:visit, :pet => @pork_chop)
      
      # make sure a dog vaccine (heartworm) is okay (valid)
      good_vaccination = FactoryGirl.build(:vaccination, :visit => @visit_pork_chop, :vaccine => @heartworm)
      assert good_vaccination.valid?
      
      # make sure a cat vaccine (leukemia) is invalid
      bad_vaccination = FactoryGirl.build(:vaccination, :visit => @visit_pork_chop, :vaccine => @leukemia)
      deny bad_vaccination.valid?
      
      # destroy the visit by Pork Chop
      @visit_pork_chop.destroy    
    end   
  end
end
