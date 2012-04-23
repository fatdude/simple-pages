class PagePart < ActiveRecord::Base
  attr_accessible :content, :name

  # Relationships
  belongs_to :page

  class << self

    def defaults
      %w{ body side footer }
    end

  end
end
