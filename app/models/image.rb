class Image < ActiveRecord::Base

  include ::Attribute::OpenAndCloseAt
  include ::Attribute::OrderOfDisplay


  parent_attrs  :folder_id

  # 
  TRANSLATION_SCOPE = ["errors", "image", "messages"].freeze
  #
  IMAGE_CONTENT_TYPE = ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif', 
                        'image/png', 'image/x-png'].freeze
  # 
  VALID_CONTENT_TYPE = IMAGE_CONTENT_TYPE 
  #
  STYLES = [:original, :medium, :small, :thumb]

  @@ordering_map = {
    Folder::ORDERING_BY_CREATED_AT_DESC =>  'created_at desc',
    Folder::ORDERING_BY_UPDATED_AT_DESC => 'updated_at desc',
    Folder::ORDERING_BY_CREATED_AT_ASC =>  'created_at asc',
    Folder::ORDERING_BY_UPDATED_AT_ASC =>  'updated_at asc',
    Folder::ORDERING_SPECIFYING => 'order_of_display, created_at asc'
  }

  # if ordering type of the folder is 'ordering_specifying'
  # set the order of display
  before_create :set_order_of_display!
  
  # 
  belongs_to  :folder
  belongs_to  :updated_by, :class_name => 'User',
              :foreign_key => 'updated_by_id'
  belongs_to  :created_by, :class_name => 'User',
              :foreign_key => 'created_by_id'
  
  scope   :listing, lambda { |folder|
    order( 
    if @@ordering_map.include?(folder.ordering_type)
      @@ordering_map[folder.ordering_type]
    else
      'created_at asc'
    end)
  }

  scope   :by_id, lambda { |id|
    where("id = ?", id)
  }
  
  # editable for the user
  scope   :editable_for, lambda { |user|
    folders = Folder.editable_for(user)
    where("folder_id in (?)", folders.collect {|folder| folder.id})
  }
  
  # the title must be present
  validates_presence_of :title

  # 公開開始日時の入力チェック.日付け要素が未入力または、全て入力されて有効な日時になっていればOK?
  validate :opened_at_must_completed_or_nil
  # 公開停止日時の入力チェック.日付け要素が未入力または、全て入力されて有効な日時になっていればOK?
  validate :closed_at_must_completed_or_nil

  @@image_config = AppConfig::Image.instance
  
  # setup about  an attached file (Paperclip)
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
  has_attached_file :image,
     :styles => {
       :medium=> @@image_config.resize_medium,  # 
       :small=> @@image_config.resize_small,  # 
       :thumb => @@image_config.resize_thumb  # 
      },
      :default_style => :original,
      :path => "#{env}#{@@image_config.path}/:class/:id_partition/:style_:basename.:extension",
#      :path => ":rails_root/assets/:class/:id_partition/:style_:basename.:extension",
      :url => "/:class/:id/:style'",
      :whiny => false

  # Restricts  file extension
  validates_attachment_content_type :image,
    :content_type => VALID_CONTENT_TYPE

  # Restricts file size
  validates_attachment_size :image,
    :less_than => 3.megabytes


  public

  # the mock uploading a file.
  def self.uploaded_file_mock(path, content_type)

    filename = File.split(path).last
    p filename
    t = Tempfile.new(filename);
    t.binmode

    FileUtils.copy_file(path, t.path)

    (class << t; self; end).class_eval do

      alias local_path path

      define_method(:original_filename) { filename }

      define_method(:content_type) { content_type }

    end

    return t

  end

  
end
