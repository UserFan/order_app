class PagesPolicy < Struct.new(:user, :pages)

  def catalog?
    #binding.pry
    user.moderator? || user.super_admin?
  end

  def home?
    true
  end

end
