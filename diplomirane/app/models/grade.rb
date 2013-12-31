class Grade < ActiveRecord::Base
	validates :number, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 50}
	validates_inclusion_of :grade, :in => ["12a","12b","12v","12g"]

end
