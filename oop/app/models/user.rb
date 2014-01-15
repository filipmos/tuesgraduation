class User < ActiveRecord::Base
	acts_as_predecessor
	validates :name, :presence => true, :uniqueness => true
end
