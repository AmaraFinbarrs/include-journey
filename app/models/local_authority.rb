# app/models/local_authority.rb
class LocalAuthority < ApplicationRecord
  has_one :user

  validates_presence_of :name

  def json
    {
      'name': name
    }
  end

  def to_csv
    [name]
  end
end
