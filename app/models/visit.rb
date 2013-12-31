class Visit < ActiveRecord::Base
    # Relationships
  # -----------------------------
  belongs_to :pet
  has_many :vaccinations
  has_many :vaccines, :through => :vaccinations
  has_one :owner, :through => :pet
  
  
  # Scopes
  # -----------------------------
  # by default, order by visits in descending order (most recent first)
   scope :chronological, lambda { order('date DESC') }
   # get all the visits by a particular pet (using the 'stabby lambda' notation here)
   scope :for_pet, ->(pet_id) { where('pet_id = ?', pet_id) }
   # get the last X visits (using the 'stabby lambda' notation here)
   scope :last, ->(num) { limit(num).order('date DESC') }

  
  # Validations
  # -----------------------------
  # old style validation for presence of pet_id and visit date
  validates_presence_of :pet_id, :date

  # weight must be present and an integer greater than 0 and less than 100 (none of our animal types will exceed)
  validates :weight, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 100 }
end
