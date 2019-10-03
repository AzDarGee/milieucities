class Ward < ApplicationRecord
  belongs_to :municipality
  validates :name,
            presence: { message: 'Name is required.' },
            uniqueness: { message: 'Name must be unique.', scope: :municipality_id }            
end
