class Folder < ActiveRecord::Base

  include ::Attribute::OpenAndCloseAt
  
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
  belongs_to  :side_widget_set, :class_name => 'WidgetSet'
  has_many    :articles,  :dependent => :destroy
  has_many    :images,  :dependent => :destroy
  has_many    :menu_items
  has_one     :page_design, :dependent => :destroy

  scope   :listing, order('updated_at desc')
  
  scope   :by_id, lambda { |id|
    where("name = ?", id)
  }
  
  scope   :by_name, lambda { |name|
    where("name = ?", name)
  }
  
  scope   :opened, where('opened_at IS NULL OR opened_at >= ?', Date.today)

  # filtering(editable for the user)
  scope   :editable_for, lambda { |user|
    if user.is_admin
      where("")
    elsif user.can_edit_site?(user.site)
      where("site_id = ?", user.site_id)
    else
      where("owner_id = ?", user.id)
    end
  }

  # filtering(can manage for the user)
  scope   :can_manage_for, lambda { |user|
    if user.is_admin
      where("")
    elsif user.can_manage_site?(user.site)
      where("site_id = ?", user.site_id)
    else
      where("owner_id = ?", user.id)
    end
  }

  validates_presence_of   :name
  validates_uniqueness_of :name, :scope => :site_id
  validates_inclusion_of  :ordering_type, :in => ORDERING_TYPES,
                          :allow_blank => false
  validates_numericality_of :article_count_by_page,
                            :greater_than_or_equal_to => 1,
                            :less_than_or_equal_to => MAX_ARTICLE_COUNT_BY_PAGE,
                            :allow_nil => false,
                            :only_integer => 1
  validates_presence_of :site_id
  
  # 公開開始日時の入力チェック.日付け要素が未入力または、全て入力されて有効な日時になっていればOK?
  validate :opened_at_must_completed_or_nil
  # 公開停止日時の入力チェック.日付け要素が未入力または、全て入力されて有効な日時になっていればOK?
  validate :closed_at_must_completed_or_nil
  

  def self.accessible_attributes
    [:name, :title, :description, :owner_id ] +
    [:opened_year, :opened_month, :opened_day, :opened_hour, :opened_min] +
    [:closed_year, :closed_month, :closed_day, :closed_hour, :closed_min ] +
    [:article_count_by_page, :ordering_type, :side_widget_set_id] +
    [:theme_name,:site]

  end

  # Returns the active page design.
  # the self.page_design will be returned if self has it. 
  # Otherwise self.site.page_design　will be returned.
  def active_page_design
    self.page_design || self.site.page_design
  end
  
  
  # array of ordeting types
  # each element - [<name for displaying>,<value for saving>]
  def self.ordering_types
    ORDERING_TYPES.collect do |type|
      [I18n.t(type.underscore, 
        :scope => [:activerecord,:attribute_values,:folder,:ordering_types]), 
      type]
    end
  end
  
  # Returns theme records (Design::Theme)
  def theme
    Design::Theme.array.find_by_name(self.theme_name) || site.theme
  end
  
  # Returns the active side widget set (self.side_widet_set or self.site.side_widget_set)
  def active_side_widget_set
    self.side_widget_set || site.side_widget_set
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
