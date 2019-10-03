class CityRequest < ApplicationRecord
  validates :city, presence: { message: I18n.t('validates.alert.cityIsRequired') }
end
