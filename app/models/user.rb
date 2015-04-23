class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts

  validate :check_seat_limit

  def to_s; email end

  def check_seat_limit
    if User.count >= License[:seats]
      errors.add(:base, "No more seats available for your license!")
    end
  end
end
