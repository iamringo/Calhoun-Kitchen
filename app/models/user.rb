require 'net/ldap'
class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :netid, :admin, :phone, :color
  has_many :reservations, :as => :renter
  has_many :reservations, :as => :manager
  named_scope :admins, lambda {{:conditions => {:admin => true}}}


    def self.import_from_ldap(netid, should_save = true)
    # Setup our LDAP connection
    ldap = Net::LDAP.new( :host => "directory.yale.edu", :port => 389 )
    begin
      # We filter results based on netid
      filter = Net::LDAP::Filter.eq("uid", netid)
      new_user = User.new(:netid => netid)
      ldap.open do |ldap|
        # Search, limiting results to yale domain and people
        ldap.search(:base => "ou=People,o=yale.edu", :filter => filter, :return_result => false) do |entry|
          new_user.first_name = entry['givenname'].first
          new_user.last_name = entry['sn'].first
          new_user.email = entry['mail'].first
        end
      end
      new_user.admin = true unless User.first
      new_user.save if should_save
    rescue Exception => e
      new_user.errors.add_to_base "LDAP Error #{e.message}" # Will trigger an error, LDAP is probably down
    end
    new_user
  end

end
