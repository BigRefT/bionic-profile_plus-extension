class HowDidYouHear < ActiveRecord::Base
  has_many :profiles, :dependent => :nullify

  acts_as_site_member
  acts_as_audited :protect => false

  attr_accessible :label, :other, :active, :position
  validates_presence_of :label
  validates_uniqueness_of :label, :scope => :site_id

  default_scope :order => :position
end