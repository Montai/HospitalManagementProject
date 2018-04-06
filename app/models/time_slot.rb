class TimeSlot < ActiveRecord::Base
	has_many :appointments
	validates :slot, presence: true, inclusion: { in: %w(9:00 11:00 1:00 3:00 5:00 7:00 9:00) }
end
