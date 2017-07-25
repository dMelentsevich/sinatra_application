class Model < ActiveRecord::Base
  def self.from_omniauth(provider, uid)
    puts "PROVIDER #{provider}"
    puts "PROVIDER #{uid}"
    where(provider: provider, uid: uid).first_or_create do |model|
      model.email = "#{provider}@#{uid}.com"
    end

    puts "EMAIL - #{Model.all.first.email}"
  end
end