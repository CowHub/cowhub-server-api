class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :cattle
  has_many :match

  def generate_token
    update_attribute('token_id', rand(10_000_000)) unless token_id
    JsonWebToken.encode(id: id, token_id: token_id)
  end
end
