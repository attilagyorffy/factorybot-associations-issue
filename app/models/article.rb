class Article < ApplicationRecord
  has_many :sections
  
  validates :title, presence: true
  validates :sections, length: { minimum: 1 }
end
