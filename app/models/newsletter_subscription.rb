class NewsletterSubscription < ApplicationRecord
  validates :email,
            presence: { message: I18n.t('validates.alert.emailIsRequired') },
            uniqueness: { message: I18n.t('validates.alert.emailAlreadyInUse') }
end
