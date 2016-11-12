class VerificationImage < ApplicationRecord
  belongs_to :cattle, optional: true
end
