class Animal < ActiveRecord::Base
    # Relationships
  # -----------------------------
  has_many :pets
  has_many :vaccines
  
  # Scopes
  # -----------------------------
  scope :alphabetical, -> { order('name') }
   
  # Validations
  # -----------------------------
  validates :name, presence: true

end
