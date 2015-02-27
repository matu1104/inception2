class User < ActiveRecord::Base

  before_validation :check_password
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation,
                  :remember_me, :username, :admin

  validates_uniqueness_of :username

  has_many :favorites

  def check_password
    # if password is empty on update then password is not modified
    self.password = nil if self.password == '' && !self.new_record?
  end
end
