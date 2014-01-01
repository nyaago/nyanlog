class PageDesign < ActiveRecord::Base


  attr_accessible :header_image, :header_color
  attr_accessible :background_image, :background_color, :background_position, :background_repeat, :background_attachment
  attr_accessible :stylesheet, :header_html, :footer_html

  # 
  TRANSLATION_SCOPE = ["errors", "page_design", "messages"].freeze
  #
  IMAGE_CONTENT_TYPE = ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif', 
                        'image/png', 'image/x-png'].freeze
  # 
  VALID_CONTENT_TYPE = IMAGE_CONTENT_TYPE 
  #
  STYLES = [:original, :thumb]
  
  #
  BACKGROUND_REPEAT_ENTRIES = %w(repeat-x repeat-y repeat no-repeat)

  #
  BACKGROUND_POSITION_ENTRIES = %w(left center right)

  #
  BACKGROUND_ATTACHMENT_ENTRIES = %w(fixed scroll)
  
  #
  belongs_to        :folder
  belongs_to        :site
  
  before_validation :set_default!
  
  #
  validates_presence_of :site_id
  #
  validates_with ::Validator::Site
  #
  validates_with ::Validator::Folder
  #
  validates_presence_of   :background_position, 
                          :if => Proc.new { |page_design| 
                                            page_design.folder.nil? || 
                                            page_design.background_interited_from_site == false }
  validates_presence_of   :background_repeat, 
                          :if => Proc.new { |page_design| 
                                            page_design.folder.nil? || 
                                            page_design.background_interited_from_site == false }

  validates_presence_of   :background_attachment, 
                          :if => Proc.new { |page_design| 
                                            page_design.folder.nil? || 
                                            page_design.background_interited_from_site == false }
  #
  validates_inclusion_of  :background_position, :in => BACKGROUND_POSITION_ENTRIES, :allow_nil => true
  #
  validates_inclusion_of  :background_repeat, :in => BACKGROUND_REPEAT_ENTRIES, :allow_nil => true
  #
  validates_inclusion_of  :background_attachment, :in => BACKGROUND_ATTACHMENT_ENTRIES, :allow_nil => true
  
  @@image_config = AppConfig::Image.instance
  
  # setup about  an header image file (Paperclip)
  env = 
  if ENV['RAILS_ENV'].nil?
    "development/"
  else
    if ENV['RAILS_ENV'] == 'production'
      ''
    else
      "#{ENV['RAILS_ENV']}/"
    end  
  end
  has_attached_file :header_image,
     :styles => {
       :thumb => @@image_config.resize_thumb  # 
      },
      :default_style => :original,
      :path => "#{env}#{@@image_config.path}/header_images/:id_partition/:style_:basename.:extension",
      :url => "/header_images/:id/:style'",
      :whiny => false

  # Restricts  file extension
  validates_attachment_content_type :header_image,
    :content_type => VALID_CONTENT_TYPE

  # Restricts file size
  validates_attachment_size :header_image,
    :less_than => 3.megabytes

  # setup about  an background image file (Paperclip)
  has_attached_file :background_image,
     :styles => {
       :thumb => @@image_config.resize_thumb  # 
      },
      :default_style => :original,
      :path => "#{env}#{@@image_config.path}/background_images/:id_partition/:style_:basename.:extension",
      :url => "/background_images/:id/:style'",
      :whiny => false

  # Restricts  file extension
  validates_attachment_content_type :background_image,
    :content_type => VALID_CONTENT_TYPE

  # Restricts file size
  validates_attachment_size :background_image,
    :less_than => 3.megabytes

  # Returns array of background posision entries.
  # Each entry is array including the human name and the name.
  def self.background_position_entries
    BACKGROUND_POSITION_ENTRIES.collect do |entry|
      [I18n.t(entry, :scope => [:activerecord, :attribute_values, :page_design, :background_position]), 
      entry]
    end
  end

  # Returns array of background repeat entries.
  # Each entry is array including the human name and the name.
  def self.background_repeat_entries
    BACKGROUND_REPEAT_ENTRIES.collect do |entry|
      [I18n.t(entry, :scope => [:activerecord, :attribute_values, :page_design, :background_repeat]), 
      entry]
    end
  end

  # Returns array of background attachment entries.
  # Each entry is array including the human name and the name.
  def self.background_attachment_entries
    BACKGROUND_ATTACHMENT_ENTRIES.collect do |entry|
      [I18n.t(entry, :scope => [:activerecord, :attribute_values, :page_design, :background_attachment]), 
      entry]
    end
  end
  
  def background_image_exist?
    self.background_image && self.background_image.size.to_i != 0
  end
  
  def header_image_exist?
    self.header_image && self.header_image.size.to_i != 0
  end
  


  private
  
  def set_default!
    self.background_position ||= 'center'
    self.background_repeat ||= 'repeat'
    self.background_attachment ||= 'fixed'
    self.background_color ||= "#ffffff"
    true
  end
  
end
