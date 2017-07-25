class User < ActiveRecord::Base
  def self.from_omniauth(auth)
    user = User.where(provider: auth.provider, uid: auth.uid).take
    if user.nil?
      user = User.create(provider: auth.provider, uid: auth.uid, name: auth.info.name)
    end

    user
  end
end