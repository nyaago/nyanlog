class Folder < ActiveRecord::Base

  include ::OpenAndCloseAt
  
  MAX_ARTICLE_COUNT_BY_PAGE = 15

  # 
  ORDERING_BY_CREATED_AT_DESC = 'ByCreatedAtDesc' 
  ORDERING_BY_UPDATED_AT_DESC = 'ByUpdatedAtDesc'
  ORDERING_BY_CREATED_AT_ASC = 'ByCreatedAtAsc'
  ORDERING_BY_UPDATED_AT_ASC = 'ByUpdatedAtAsc'
  ORDERING_SPECIFYING = 'Specifying'
  ORDERING_TYPES = [
    ORDERING_BY_CREATED_AT_DESC,
    ORDERING_BY_UPDATED_AT_DESC,
    ORDERING_BY_CREATED_AT_ASC,
    ORDERING_BY_UPDATED_AT_ASC,
    ORDERING_SPECIFYING
    ]

  # if ordering type is 'ordering_specifying'
  # the order of  display of articles is set 
  after_save :set_order_of_articles_if_ordering_specifying_type!

  # if ordering type is 'ordering_specifying'
  # the order of  display of images is set 
  after_save :set_order_of_images_if_ordering_specifying_type!
  
  
  belongs_to  :site
  belongs_to  :owner, :class_name => 'User',
              :foreign_key => 'owner_id'
  belongs_to  :updated_by, :class_name => 'User',
              :foreign_key => 'updated_by_id'
  belongs_to  :created_by, :class_name => 'User',
              :foreign_key => 'created_by_id'
  belongs_to  :owner, :class_name => 'User',
              :foreign_key => 'owner_id'
  has_many    :articles,  :dependent => :destroy
  has_many    :images,  :dependent => :destroy

  scope   :listing, order('updated_at desc')
  
  scope   :by_id, lambda { |id|
    where("name = ?", id)
  }
  
  scope   :by_name, lambda { |name|
    where("name = ?", name)
  }
  
  scope   :opened, where('opened_at IS NULL OR opened_at >= ?', Date.today)

  validates_presence_of   :name
  validates_uniqueness_of :name, :scope => :site_id
  validates_inclusion_of  :ordering_type, :in => ORDERING_TYPES,
                          :allow_blank => false
  validates_numericality_of :article_count_by_page,
                            :greater_than_or_equal_to => 1,
                            :less_than_or_equal_to => MAX_ARTICLE_COUNT_BY_PAGE,
                            :allow_nil => false,
                            :only_integer => 1
  
  # 公開開始日時の入力チェック.日付け要素が未入力または、全て入力されて有効な日時になっていればOK?
  validate :opened_at_must_completed_or_nil
  # 公開停止日時の入力チェック.日付け要素が未入力または、全て入力されて有効な日時になっていればOK?
  validate :closed_at_must_completed_or_nil
  
  
  # array of ordeting types
  # each element - [<name for displaying>,<value for saving>]
  def self.ordering_types
    ORDERING_TYPES.collect do |type|
      [I18n.t(type.underscore, 
        :scope => [:activerecord,:attributes,:folder,:ordering_types]), 
      type]
    end
  end
  
  # the order of  display of articles is set 
  def set_order_of_articles!
    n = 1
    articles.order('order_of_display, created_at asc').each do |article|
      article.order_of_display = n
      n += 1
      class << article
        def record_timestamps; false; end
      end
      article.save!(:validate => false)
    end
  end

  # if ordering type is 'ordering_specifying'
  # the order of  display of articles is set 
  def set_order_of_articles_if_ordering_specifying_type!
    if ordering_type == ORDERING_SPECIFYING
      set_order_of_articles!
    end
  end

  # the order of  display of images is set 
  def set_order_of_images!
    n = 1
    images.order('order_of_display, created_at asc').each do |image|
      image.order_of_display = n
      n += 1
      class << image
        def record_timestamps; false; end
      end
      image.save!(:validate => false)
    end
  end

  # if ordering type is 'ordering_specifying'
  # the order of  display of images is set 
  def set_order_of_images_if_ordering_specifying_type!
    if ordering_type == ORDERING_SPECIFYING
      set_order_of_images!
    end
  end

  
  def ordered_by_specification?
     ordering_type == ORDERING_SPECIFYING
  end

  private 
  
end
