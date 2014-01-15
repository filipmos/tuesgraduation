class DiplomaWork < ActiveRecord::Base
	validates :title, :presence => true, :uniqueness => true
	validates :description, :presence => true
	validates :diploma_supervisor_id,	:numericality => true
	validates :reviewer_id,	:numericality => true, :unless => lambda { self.reviewer_id.nil? }
	validate :diploma_supervisor_must_be_different_from_reviewer_id
	validates_inclusion_of :covenanted, :in => [true,false]
	validates_inclusion_of :approved, :in => [true,false]


	def diploma_supervisor_must_be_different_from_reviewer_id
		errors.add(:reviewer, "Reviewer must be different fron Diploma Supervisor") unless
       self.diploma_supervisor_id != self.reviewer_id
	end

	def diplomanti_names
		@diplomanti= Array.new
		@diplomants= Student.find_by_sql("SELECT * from students WHERE diploma_work_id = '#{self.id}'")
			@diplomants.each do |d|
				@diplomanti << d.name
			end
			@diplomanti
	end

	def diplomanti
		@diplomants= Student.find_by_sql("SELECT * from students WHERE diploma_work_id = '#{self.id}'")
			@diplomants
	end

end
