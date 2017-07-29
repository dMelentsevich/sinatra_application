class User < ActiveRecord::Base
  def self.from_omniauth(auth)
    user = User.find_by(provider: auth.provider, uid: auth.uid)
  end
end