class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  def admin?
    self.role == "admin"
  end

  def to_admin
    self.update_columns(role: "admin")
  end
  
  def to_normal
    self.update_columns(role: "normal")
  end
end
