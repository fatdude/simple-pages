class ControllerAction < ActiveRecord::Base
  attr_accessible :action, :controller

  # Relationships
  belongs_to :page

  # Scopes
  scope :available, where(page_id: nil)

  def to_s
    "#{self.controller}::#{self.action}"
  end
end
