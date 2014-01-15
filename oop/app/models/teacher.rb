require 'digest/sha2'
class Teacher < ActiveRecord::Base
	child_of :user

  validates_presence_of :business

	validates :password, :confirmation => true
  attr_accessor :password_confirmation
  attr_reader   :password

	validate  :password_must_be_present
  
  def Teacher.authenticate(name, password)
    if teacher = find_by_name(name)
      if teacher.hashed_password == encrypt_password(password, teacher.salt)
        teacher
      end
    end
  end

  def Teacher.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "interesno" + salt)
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
