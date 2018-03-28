class TimeSlot < ActiveRecord::Base
	has_many :appointments
end
