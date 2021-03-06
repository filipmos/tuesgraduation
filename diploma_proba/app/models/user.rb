require 'digest/sha2'

class User < ActiveRecord::Base
	validates :first_name, :second_name, :last_name, :presence => true 
  validates :name, :presence => true, :uniqueness => true

	
	validates_presence_of :business, :unless => lambda { self.user_type == "student" }
	validates_presence_of :number, :unless => lambda { self.user_type == "graduation supervisor" or self.user_type == "teacher" }

  validates :password, :confirmation => true
  attr_accessor :password_confirmation
  attr_reader   :password

	validates_inclusion_of :grade, :in => ["","12a","12b","12v","12g"], :unless => lambda { self.user_type == "graduation supervisor" or self.user_type == "teacher" }
	validates_inclusion_of :access, :in => %w(user admin)
	validates_inclusion_of :user_type, :in => ["student", "teacher", "graduation supervisor"]
	validates_inclusion_of :active, :in => [0,1]

  validate  :password_must_be_present
  
  def User.authenticate(name, password)
    if user = find_by_name(name)
      if user.hashed_password == encrypt_password(password, user.salt)
        user
      end
    end
  end

  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "wibble" + salt)
  end
  
  # 'password' is a virtual attribute
  def password=(password)
    @password = password

    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end
  
  private

    def password_must_be_present
      errors.add(:password, "Missing password") unless hashed_password.present?
    end
  
    def generate_salt
      self.salt = self.object_id.to_s + rand.to_s
    end
end

