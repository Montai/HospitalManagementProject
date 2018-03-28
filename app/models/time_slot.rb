class TimeSlot < ActiveRecord::Base
	has_many :appointments
	validates :slot, presence: true
end
