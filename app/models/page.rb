class Page < ActiveRecord::Base
  attr_accessible :ancestry, :display_in_menu, :link, :status, :title, :url, :parent_id, :controller_action_ids, :page_parts_attributes, :name, :position
  has_ancestry orphan_strategy: :rootify, cache_depth: true

  # Filters
  after_initialize :build_page_parts
  before_validation :set_link
  before_create lambda { self.position = Page.count + 1 }

  # Relationships
  has_many :controller_actions, dependent: :nullify
  has_many :page_parts, dependent: :destroy

  # Scopes
  scope :published, where(status: 1)
  scope :displayed_in_menu, where(display_in_menu: true)

  # Validations
  validates :title, :link, :status, :name, presence: true
  validates :status, inclusion: [0, 1]
  validates :url, uniqueness: true, allow_blank: true

  accepts_nested_attributes_for :page_parts, allow_destroy: true

  def published?
    self.status == 1
  end

  def content(name = 'body')
    self.page_parts.detect { |page_part| page_part.name == name }
  end

  class << self

    def statuses
      { 0 => 'Draft', 1 => 'Published' }
    end

    def for_request(request)
      path = request.fullpath
      path.gsub!(/\?.*/, '')

      where{(url == path) | ((controller_actions.controller == request.params[:controller]) & (controller_actions.action == request.params[:action]))}.joins{controller_actions.outer}
    end

  end

  protected

    def build_page_parts
      if self.new_record? && self.page_parts.empty?
        PagePart.defaults.each do |page_part|
          self.page_parts.build name: page_part
        end
      end
    end

    def set_link
      self.link = self.title if self.link.blank?
    end
end
