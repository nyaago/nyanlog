class Article < ActiveRecord::Base

  include ::Attribute::OpenAndCloseAt
  include ::Attribute::OrderOfDisplay
  
  #
  # Attribute::OrderOfDisplay::StaticMethods.parent_attrs
  parent_attrs  :folder_id
  
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
  
  belongs_to  :folder
  belongs_to  :updated_by, :class_name => 'User',
              :foreign_key => 'updated_by_id'
  belongs_to  :created_by, :class_name => 'User',
              :foreign_key => 'created_by_id'
  
  #
  scope   :listing, lambda { |folder|
    order( 
    if @@ordering_map.include?(folder.ordering_type)
      @@ordering_map[folder.ordering_type]
    else
      'created_at asc'
    end)
  }
  #
  scope   :by_id, lambda { |id|
    where("id = ?", id)
  }
  
  # editable for the user
  scope   :editable_for, lambda { |user|
    folders = Folder.editable_for(user)
    where("folder_id in (?)", folders.collect {|folder| folder.id})
  }

  # recently updated months
  # ym attribute (%Y.%m.1) is included in records
  scope :recently_updated_ym, lambda { |limit|
    select("DATE_FORMAT(updated_at, '%Y.%m.1') as ym").
    group('ym').
    order("ym DESC").
    limit(limit)
  }

  # recently updated 
  scope :recently_updated, lambda { |limit|
    order("updated_at DESC").
    limit(limit)
  }
  # filtering by the month when articles was updated
  scope :by_updated_month, lambda { |month|
    month = if month.instance_of?(String);Date.parse(month);else;month;end
    where("updated_at >= ? and updated_at < ?", 
          month.beginning_of_month, month.next_month.beginning_of_month)
  }

  # the title must be present
  validates_presence_of :title

  # 公開開始日時の入力チェック.日付け要素が未入力または、全て入力されて有効な日時になっていればOK?
  validate :opened_at_must_completed_or_nil
  # 公開停止日時の入力チェック.日付け要素が未入力または、全て入力されて有効な日時になっていればOK?
  validate :closed_at_must_completed_or_nil
  
  def self.accessible_attributes
    @accessible_attributes ||= [:title, :content] +
    [:opened_year, :opened_month, :opened_day, :opened_hour, :opened_min] +
    [:closed_year, :closed_month, :closed_day, :closed_hour, :closed_min]
  end

end
