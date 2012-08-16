class PagePart < ActiveRecord::Base
  attr_accessible :content, :name, :filter

  # Relationships
  belongs_to :page

  class << self

    def defaults
      %w{ body side footer }
    end

    def filters
      { 0 => 'Markdown', 1 => 'HTML' }
    end

  end
end
