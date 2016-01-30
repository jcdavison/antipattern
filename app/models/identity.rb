class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.build_for_oauth(auth)
    provider = auth.provider.match(/github/) ? 'github' : auth.provider
    identity = find_or_create_by(uid: auth.uid, provider: provider)
    identity.set_scope(auth)
    identity 
  end

  def set_scope(auth)
    self.private_scope = auth.provider.match(/private/) ? true : false
    self.save
  end
end
